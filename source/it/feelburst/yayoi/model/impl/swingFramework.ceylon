import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	InterfaceDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LookAndFeelAction,
	LayoutAction
}
import it.feelburst.yayoi.behaviour.action.swing {
	SwingLookAndFeelAction,
	SwingLayoutAction
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegistry
}
import it.feelburst.yayoi.model {
	ActionConstructor,
	ComponentConstructor,
	Framework
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.component.swing {
	SwingComponent
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.container.swing {
	SwingContainer,
	SwingLayout
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.listener.awt {
	AwtListener
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.model.window.swing {
	SwingWindow
}
import it.feelburst.yayoi.\iobject.listener.awt {
	DefaultWindowClosingAdapter
}

import java.awt {
	Wndw=Window,
	LayoutManager,
	JContainer=Container
}
import java.lang {
	Types {
		classForDeclaration,
		classForType
	}
}
import java.util {
	EventListener
}

import javax.swing {
	JDialog,
	JWindow,
	JFrame,
	JComponent
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

shared object swingFramework extends Framework("swing") {
	value cmpConstrs = map({
		`interface Component` -> componentConstr,
		`interface Container` -> containerConstr,
		`interface Window` -> windowConstr,
		`interface Layout` -> layoutConstr,
		`interface Listener` -> listenerConstr
	});
	value actConstrs = map({
		`interface LayoutAction` -> layoutActionConstr,
		`interface LookAndFeelAction` -> lookAndFeelActionConstr
	});
	shared actual ComponentConstructor componentConstructor(
		InterfaceDeclaration constrIntr) {
		if (exists cmpCnstr = cmpConstrs[constrIntr]) {
			return cmpCnstr;
		}
		else {
			value message = "Component constructor not found.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual ActionConstructor actionConstructor(
		InterfaceDeclaration constrIntr) {
		if (exists actCnstr = actConstrs[constrIntr]) {
			return actCnstr;
		}
		else {
			value message = "Action constructor not found.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual ClassDeclaration defaultWindowClosingListener() =>
			`class DefaultWindowClosingAdapter`;
}

shared sealed abstract class SwingComponentConstructor() satisfies ComponentConstructor {
	
	shared Type() internalConstructor<Type>(
		String cmpntName,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context)
		given Type satisfies Object =>
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
				assert (is Type intrnlCmp = context.getBean(name,classForDeclaration(decl)));
				log.debug("Internal Component '``name``' constructed.");
				return intrnlCmp;
			}
			else {
				Type intrnlCmp {
					try {
						switch (decl)
						case (is FunctionDeclaration) {
							value cmpRgstr = context.getBean(classForType<ComponentRegistry>());
							value atwrdIntrnlCmp = cmpRgstr.autowired<Type>(cmpntName,decl);
							log.debug("Components autowired for component '``name``'.");
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
	
}

shared object componentConstr extends SwingComponentConstructor() {
	shared actual Component<JComponent> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JComponent>(name,decl,context)))
		SwingComponent(name,decl,vl,publishEventByContext(context));
}

shared object containerConstr extends SwingComponentConstructor() {
	shared actual Container<JContainer,Object> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JContainer>(name,decl,context)))
		SwingContainer<JContainer,Object>(name,decl,vl,publishEventByContext(context));
}

shared object windowConstr extends SwingComponentConstructor() {
	shared actual Window<Wndw> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<JFrame|JDialog|JWindow>(name,decl,context)))
		SwingWindow(name,decl,vl,publishEventByContext(context));
}

shared object layoutConstr extends SwingComponentConstructor() {
	shared actual Layout<LayoutManager> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<LayoutManager>(name,decl,context)))
		SwingLayout(name,decl,vl,publishEventByContext(context));
}

shared object listenerConstr extends SwingComponentConstructor() {
	shared actual Listener<EventListener> construct(
		String name,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		AnnotationConfigApplicationContext context) =>
		let (vl = LateValue(internalConstructor<EventListener>(name,decl,context)))
		AwtListener(name,decl,vl,publishEventByContext(context));
}

shared object layoutActionConstr satisfies ActionConstructor {
	shared actual LayoutAction construct(
		String name,
		FunctionDeclaration decl,
		ApplicationContext context) =>
		SwingLayoutAction(name,decl,context);
}

shared object lookAndFeelActionConstr satisfies ActionConstructor {
	shared actual LookAndFeelAction construct(
		String name,
		FunctionDeclaration decl,
		ApplicationContext context) =>
		SwingLookAndFeelAction(name,decl,context);
}