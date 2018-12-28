import ceylon.interop.java {
	CeylonCollection
}
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
	NameResolver,
	ComponentRegistry
}
import it.feelburst.yayoi.marker {
	cltValue=collectValue,
	NamedAnnotation,
	rmvValue=removeValue
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
import it.feelburst.yayoi.model.impl {
	LateValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.setting {
	CollectValueSetting,
	RemoveValueSetting,
	LookAndFeelSetting,
	AbstractCollectRemoveValueSetting
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

import org.springframework.context {
	ApplicationContext
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}
import org.springframework.beans.factory.support {

	GenericBeanDefinition
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
	shared formal {FunctionDeclaration*} defaultCollectValues();
	shared formal {FunctionDeclaration*} defaultRemoveValues();
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
		Container<Object,Object>|
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
				log.debug("Internal Component '``name``' definition registered.");
				assert (is Type intrnlCmp = context
					.getBean(name,classForDeclaration(decl)));
				log.debug("Internal Component '``name``' constructed.");
				return intrnlCmp;
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
								"Internal Component '``name``' has not been constructed " +
								"due to the following error: ``e.message``";
						log.error(message);
						throw Exception(message);
					}
				}
				value intCmp = intrnlCmp;
				log.debug("Internal Component '``name``' constructed.");
				context.beanFactory.registerSingleton(name, intCmp);
				log.debug("Internal Component '``name``' registered.");
				return intrnlCmp;
				
			}
		});
	
	shared Anything(Object,Object) collectRemoveValue<CollectRemoveSetting>(
		String cltrName,
		AnnotationConfigApplicationContext context)
		given CollectRemoveSetting satisfies AbstractCollectRemoveValueSetting {
		value nmRslvr = context.getBean(classForType<NameResolver>());
		value lateCltRmvValues = LateValue(() =>
			CeylonCollection(context
			.getBeansOfType(classForType<CollectRemoveSetting>())
			.values())
			.sort((CollectRemoveSetting x, CollectRemoveSetting y) =>
				x <=> y));
		return (Object cltr,Object cltd) {
			value itr = lateCltRmvValues.val.iterator();
			while (is CollectRemoveSetting cltRmvVlStng = itr.next()) {
				if (cltRmvVlStng.decl.parameterDeclarations.size == 2,
					is ValueDeclaration[2] prmtrDecls =
					cltRmvVlStng.decl.parameterDeclarations) {
					value [cltrPrmtrDecl,cltdPrmtrDecl] = prmtrDecls;
					
					Anything call() {
						try {
							log.debug(
								"Calling collect/remove method '``cltRmvVlStng``' " +
								"with collector '``cltr``' and collected '``cltd``'...");
							return cltRmvVlStng.val(cltr,cltd);
						}
						catch (IncompatibleTypeException e) {
							throw Exception(
								"Collected '``cltd``' cannot be added to/removed from " +
								"collector '``cltr``'. Add/remove method of setting " +
								"declaration '``cltRmvVlStng.decl``' " +
								"is not suitable: ``e.message``");
						}
					}
					function sameCltr(NamedAnnotation cltrPrmtrDeclNmd) =>
						nmRslvr.resolveNamed(
							cltRmvVlStng.decl,
							cltrPrmtrDeclNmd) == cltrName;
					
					function sameCltd(NamedAnnotation cltdPrmtrDeclNmd) =>
						let (prmtCltd = (() {
							assert (is 
								Component<Object>|
								Collection<Object>|
								Container<Object,Object>|
								Window<Object>|
								Listener<Object> cltd = context.getBean(
									nmRslvr.resolveNamed(
										cltRmvVlStng.decl, 
										cltdPrmtrDeclNmd), 
									classForType<Named>()));
							return cltd;
						})())
						prmtCltd.val == cltd;
						
					
					if (exists cltrPrmtrDeclNmd =
						annotations(`NamedAnnotation`,cltrPrmtrDecl),
						exists cltdPrmtrDeclNmd =
						annotations(`NamedAnnotation`,cltdPrmtrDecl)) {
						if (sameCltr(cltrPrmtrDeclNmd),
							sameCltd(cltdPrmtrDeclNmd)) {
							return call();
						}
						else {
							log.warn(
								"Declaration '``cltRmvVlStng.decl``' is not suitable " +
								"for collector '``cltr``' and collected '``cltd``'. " +
								"Collector and collected refer to specific components.");
							continue;
						}
					}
					else if (
						!annotations(`NamedAnnotation`,cltrPrmtrDecl) exists,
						exists cltdPrmtrDeclNmd =
						annotations(`NamedAnnotation`,cltdPrmtrDecl)) {
						if (sameCltd(cltdPrmtrDeclNmd)) {
							return call();
						}
						else {
							log.warn(
								"Declaration '``cltRmvVlStng.decl``' is not suitable " +
								"for collector '``cltr``' and collected '``cltd``'. " +
								"Collected refers to specific component.");
							continue;
						}
					}
					else if (
						exists cltrPrmtrDeclNmd =
						annotations(`NamedAnnotation`,cltrPrmtrDecl),
						!annotations(`NamedAnnotation`,cltdPrmtrDecl) exists) {
						if (sameCltr(cltrPrmtrDeclNmd)) {
							return call();
						}
						else {
							log.warn(
								"Declaration '``cltRmvVlStng.decl``' is not suitable " +
								"for collector '``cltr``' and collected '``cltd``'. " +
								"Collector refers to specific component.");
							continue;
						}
					}
					else {
						try {
							log.debug(
								"Calling collect/remove method '``cltRmvVlStng``' " +
								"with collector '``cltr``' and collected '``cltd``'...");
							return cltRmvVlStng.val(cltr,cltd);
						}
						catch (IncompatibleTypeException e) {
							log.debug(
								"Declaration '``cltRmvVlStng.decl``' is not suitable " +
								"for collector '``cltr``' and collected '``cltd``'.");
							continue;
						}
						catch (Exception e) {
							throw e;
						}
					}
				}
				else {
					log.warn(
						"Declaration '``cltRmvVlStng.decl``' may have only " +
						"2 value parameters, the first being the collector and the " +
						"second being the collected.");
				}
			}
			value message =
				"Collected '``cltd``' cannot be added to/removed from collector '``cltr``'. " +
				"No suitable add/remove method has been found. " +
				"Use '`` `function cltValue`.name ``'/" +
				"'`` `function rmvValue`.name ``' annotation to define it.";
			throw Exception(message);
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
		LookAndFeelSetting|CollectValueSetting|RemoveValueSetting,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration,
		ApplicationContext> {}
