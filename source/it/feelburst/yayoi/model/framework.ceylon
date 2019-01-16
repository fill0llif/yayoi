import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	NestableDeclaration,
	Package
}
import ceylon.language.meta.model {
	IncompatibleTypeException
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegistry
}
import it.feelburst.yayoi.marker {
	CollectingAnnotation,
	CollectableAnnotation,
	collectable,
	Collecting
}
import it.feelburst.yayoi.model.collection {
	Collection
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.setting {
	LookAndFeelSetting
}
import it.feelburst.yayoi.model.setting.impl {
	LookAndFeelSettingImpl
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.lang {
	Types {
		classForType,
		classForDeclaration
	}
}
import java.util.concurrent {
	ExecutorService
}

import org.springframework.beans.factory.support {
	GenericBeanDefinition
}
import org.springframework.context {
	ApplicationContext
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}

shared abstract class Framework(shared String name) {
	shared formal {Package*} packages;
	shared formal ConstructorType constructor<
		Type,
		Decl,
		Context=ApplicationContext,
		ConstructorType=Constructor<Type,Decl,Context>>(
		InterfaceDeclaration constrIntr)
		given Type satisfies Object
		given Decl satisfies NestableDeclaration
		given Context satisfies ApplicationContext
		given ConstructorType satisfies Constructor<Type,Decl,Context>;
	shared formal void setLookAndFeel(ApplicationContext context);
	shared formal void waitForWindowsToClose();
	shared formal ClassDeclaration defaultWindowClosingListener();
}

shared interface Constructor<Type,Decl,Context>
	given Type satisfies Object
	given Decl satisfies NestableDeclaration
	given Context satisfies ApplicationContext {
	shared formal Type construct(
		String name,
		Decl decl,
		Context context);
}

shared interface ComponentConstructor
	satisfies Constructor<
		Component<Object>|
		Container<Object>|
		Collection<Object>|
		Window<Object>|
		Layout<Object>|
		Listener<Object>,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration,
		AnnotationConfigApplicationContext> {
			
	shared Anything(Object) publishEvent(
		AnnotationConfigApplicationContext context) =>
		let (executorService = context.getBean(classForType<ExecutorService>()))
		let (publishEvent =
			(Object event) =>
				executorService.execute(() =>
					context.publishEvent(event)))
		publishEvent;
			
	shared Type() internalConstructor<Type>(
		String cmpntName,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context)
		given Type satisfies Object =>
		let (cmpRgstr = context.getBean(classForType<ComponentRegistry>()))
		(() {
			value name = "``cmpntName``.val";
			if (is ClassDeclaration decl) {
				context.registerBeanDefinition(
					name, 
					object extends GenericBeanDefinition() {
						setBeanClass(classForDeclaration(decl));
						lazyInit = false;
						abstract = false;
						autowireCandidate = true;
						scope = "singleton";
					});
				log.debug("Internal component '``name``' registered.");
				log.debug("Internal component '``name``' constructed.");
				try {
					assert (is Type intrnlCmp = context
						.getBean(name,classForDeclaration(decl)));
					return intrnlCmp;
				}
				catch (Exception e) {
					value message =
						"Internal component '``name``' cannot be retrieved due to " +
						"the following error: ``e.message``.";
					log.error(message);
					throw Exception(message);
				}
			}
			else {
				Type intrnlCmp {
					try {
						switch (decl)
						case (is FunctionDeclaration) {
							value atwrdIntrnlCmp = cmpRgstr
								.autowired<Type>(cmpntName,decl);
							log.debug(
								"Components autowired for component '``name``'.");
							value intrnlCmpRslt = atwrdIntrnlCmp();
							if (is Exception intrnlCmpRslt) {
								throw intrnlCmpRslt;
							}
							else {
								return intrnlCmpRslt;
							}
						}
						case (is ValueDeclaration) {
							return decl.apply<Type>().get();
						}
					}
					catch (Exception e) {
						value message =
							"Internal component '``name``' has not been constructed " +
							"due to the following error: ``e.message``";
						log.error(message);
						throw Exception(message);
					}
				}
				value intCmp = intrnlCmp;
				log.debug("Internal component '``name``' constructed.");
				context.beanFactory.registerSingleton(name, intCmp);
				log.debug("Internal component '``name``' registered.");
				return intrnlCmp;
			}
		});
	
	function callCltrMethod
	({Collecting+} anns,FunctionDeclaration mthdDecl)
	(Object cltr,Object cltbl) {
		value itr = anns.iterator();
		while (is Collecting ann = itr.next()) {
			assert (exists cntr = ann.collector.get());
			try {
				log.debug(
					"Calling collect/remove method of '``ann.collector``' " +
					"with collector '``cltr``' and collectable '``cltbl``'...");
				value rslt = mthdDecl.memberInvoke(cntr, [], *({cltr,cltbl}));
				log.debug(
					"Collect/remove method of '``ann.collector``' with collector " +
					"'``cltr``' and collectable '``cltbl``' successfully called.");
				return rslt;
			}
			catch (IncompatibleTypeException e) {
				log.warn(
					"Collectable '``cltbl``' cannot be added to/removed from " +
					"collector '``cltr``'. Collect/remove method of " +
					"'``ann.collector``' is not suitable: ``e.message``");
				continue;
			}
		}
		throw Exception(
			"Collectable '``cltbl``' cannot be added to/removed from " +
			"collector '``cltr``'. No suitable collect/remove method found in neither " +
			"of the following collectors: ``anns*.collector``.");
	}
	
	shared Anything(String,Object,String,Object) collecting(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context,
		FunctionDeclaration mthdDecl) {
		return (String cltrName,Object cltr,String cltblName,Object cltbl) {
			assert (is 
				Component<Object>|
				Collection<Object>|
				Container<Object>|
				Window<Object>|
				Listener<Object> cltblCmp =
				context.getBean(cltblName,classForType<Named>()));
			if (nonempty cltblAnn = annotations(`CollectableAnnotation`,cltblCmp.decl)) {
				return callCltrMethod(cltblAnn,mthdDecl)(cltr,cltbl);
			}
			else if (exists cltngAnn = annotations(`CollectingAnnotation`,decl)) {
				return callCltrMethod({cltngAnn},mthdDecl)(cltr,cltbl);
			}
			else {
				throw Exception(
					"No suitable collector has been found for component '``name``'. " +
					"Use '`` `function collecting`.name ``' or " +
					"'`` `function collectable`.name ``' annotations to point " +
					"to a collector.");
			}
		};
	}
	
}

shared interface ActionConstructor
	satisfies Constructor<
		LayoutAction,
		FunctionDeclaration,
		ApplicationContext> {}

shared interface SettingConstructor
	satisfies Constructor<
		LookAndFeelSetting,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration,
		ApplicationContext> {}

shared object lookAndFeelSettingConstr satisfies SettingConstructor {
	shared actual LookAndFeelSetting construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ApplicationContext context) {
		assert (is ValueDeclaration decl);
		return LookAndFeelSettingImpl(name,decl);
	}
}
