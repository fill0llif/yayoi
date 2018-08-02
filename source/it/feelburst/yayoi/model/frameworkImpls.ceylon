import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.behaviour.action.impl {
	LayoutActionImpl
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

import java.awt {
	JContainer=Container,
	LayoutManager
}
import java.lang {
	Types {
		classForDeclaration
	}
}
import java.util {
	EventListener
}

import javax.swing {
	JFrame
}

import org.springframework.beans.factory.support {
	GenericBeanDefinition
}
import org.springframework.context {
	ApplicationEvent
}

shared String swingFramework = "swing";

"Implementations of components by framework"
shared Map<String,Map<InterfaceDeclaration,ClassDeclaration>>
	frameworkImpls = map({
		swingFramework -> map({
		`interface Component` -> `class SwingComponent`,
		`interface Container` -> `class SwingContainer`,
		`interface Window` -> `class SwingWindow`,
		`interface Layout` -> `class SwingLayout`,
		`interface Listener` -> `class AwtListener`,
		`interface LayoutAction` -> `class LayoutActionImpl`
		})
	});

"Constructors of component constructor implementations by framework"
shared Map<
	String,
	Map<InterfaceDeclaration,
	<
		Component<JContainer>
			(String,Source<JContainer>,Anything(ApplicationEvent))|
		Container<JContainer,LayoutManager>
			(String,Source<JContainer>,Anything(ApplicationEvent))|
		Window<JFrame>
			(String,Source<JFrame>,Anything(ApplicationEvent))|
		Layout<LayoutManager>
			(String,Source<LayoutManager>,Anything(ApplicationEvent))|
		Listener<EventListener>
			(String,Source<EventListener>,Anything(ApplicationEvent))>(ClassDeclaration)>>
	frameworkConstrImplConstrs = map({
		swingFramework -> map({
			`interface Component` -> ((ClassDeclaration decl) {
				assert (exists cmpImplDfltCnst = decl.defaultConstructor);
				return cmpImplDfltCnst
					.apply<Component<JContainer>,[String,Source<JContainer>,Anything(ApplicationEvent)]>(`JContainer`);
			}),
			`interface Container` -> ((ClassDeclaration decl) {
				assert (exists cmpImplDfltCnst = decl.defaultConstructor);
				return cmpImplDfltCnst
					.apply<Container<JContainer,LayoutManager>,[String,Source<JContainer>,Anything(ApplicationEvent)]>(`JContainer`,`LayoutManager`);
			}),
			`interface Window` -> ((ClassDeclaration decl) {
				assert (exists cmpImplDfltCnst = decl.defaultConstructor);
				return cmpImplDfltCnst
					.apply<Window<JFrame>,[String,Source<JFrame>,Anything(ApplicationEvent)]>(`JFrame`);
			}),
			`interface Layout` -> ((ClassDeclaration decl) {
				assert (exists cmpImplDfltCnst = decl.defaultConstructor);
				return cmpImplDfltCnst
					.apply<Layout<LayoutManager>,[String,Source<LayoutManager>,Anything(ApplicationEvent)]>(`LayoutManager`);
			}),
			`interface Listener` -> ((ClassDeclaration decl) {
				assert (exists cmpImplDfltCnst = decl.defaultConstructor);
				return cmpImplDfltCnst
					.apply<Listener<EventListener>,[String,Source<EventListener>,Anything(ApplicationEvent)]>(`EventListener`);
			})
		})
});

"Constructors of internal component constructors by framework.
 Each constructor lazily constructs and registers the internal component."
shared Map<
		String,
		Map<InterfaceDeclaration,
			JContainer()
				(FunctionDeclaration|ValueDeclaration,
				String,
				Anything(String,Object)) |
			JFrame()
				(FunctionDeclaration|ValueDeclaration,
				String,
				Anything(String,Object)) |
			LayoutManager()
				(FunctionDeclaration|ValueDeclaration,
				String,
				Anything(String,Object)) |
			EventListener()
				(FunctionDeclaration|ValueDeclaration,
				String,
				Anything(String,Object))>>
	frameworkIntrnlCmpConstrConstrs = map({
		swingFramework -> map({
			`interface Component` -> (
				(FunctionDeclaration|ValueDeclaration decl,
				String cmpntName,
				void register(String name,Object obj)) {
				value internalComponentConstructor {
					switch (decl)
					case (is FunctionDeclaration) {
						return decl.apply<JContainer,[]>();
					}
					case (is ValueDeclaration) {
						return decl.apply<JContainer>().get;
					}
				}
				return () {
					value name = "``cmpntName``.val";
					value intrnlCmp = internalComponentConstructor();
					log.info("Internal Component '``name``' constructed.");
					register(name, intrnlCmp);
					log.debug("Internal Component '``name``' registered.");
					return intrnlCmp;
				};
			}),
			`interface Container` -> (
				(FunctionDeclaration|ValueDeclaration decl,
				String cmpntName,
				void register(String name,Object obj)) {
				value internalComponentConstructor {
					switch (decl)
					case (is FunctionDeclaration) {
						return decl.apply<JContainer,[]>();
					}
					case (is ValueDeclaration) {
						return decl.apply<JContainer>().get;
					}
				}
				return () {
					value name = "``cmpntName``.val";
					value intrnlCmp = internalComponentConstructor();
					log.info("Internal Component '``name``' constructed.");
					register(name, intrnlCmp);
					log.debug("Internal Component '``name``' registered.");
					return intrnlCmp;
				};
			}),
			`interface Window` -> (
				(FunctionDeclaration|ValueDeclaration decl,
				String cmpntName,
				void register(String name,Object obj)) {
				value internalComponentConstructor {
					switch (decl)
					case (is FunctionDeclaration) {
						return decl.apply<JFrame,[]>();
					}
					case (is ValueDeclaration) {
						return decl.apply<JFrame>().get;
					}
				}
				return () {
					value name = "``cmpntName``.val";
					value intrnlCmp = internalComponentConstructor();
					log.info("Internal Component '``name``' constructed.");
					register(name, intrnlCmp);
					log.debug("Internal Component '``name``' registered.");
					return intrnlCmp;
				};
			}),
			`interface Layout` -> (
				(FunctionDeclaration|ValueDeclaration decl,
				String cmpntName,
				void register(String name,Object obj)) {
				value internalComponentConstructor {
					switch (decl)
					case (is FunctionDeclaration) {
						return decl.apply<LayoutManager,[]>();
					}
					case (is ValueDeclaration) {
						return decl.apply<LayoutManager>().get;
					}
				}
				return () {
					value name = "``cmpntName``.val";
					value intrnlCmp = internalComponentConstructor();
					log.info("Internal Component '``name``' constructed.");
					register(name, intrnlCmp);
					log.debug("Internal Component '``name``' registered.");
					return intrnlCmp;
				};
			}),
			`interface Listener` -> (
				(FunctionDeclaration|ValueDeclaration decl,
				String cmpntName,
				void register(String name,Object obj)) {
				value internalComponentConstructor {
					switch (decl)
					case (is FunctionDeclaration) {
						return decl.apply<EventListener,[]>();
					}
					case (is ValueDeclaration) {
						return decl.apply<EventListener>().get;
					}
				}
				return () {
					value name = "``cmpntName``.val";
					value intrnlCmp = internalComponentConstructor();
					log.info("Internal Component '``name``' constructed.");
					register(name, intrnlCmp);
					log.debug("Internal Component '``name``' registered.");
					return intrnlCmp;
				};
			})
		})
});

"Constructors of internal component constructors by framework.
 Each constructor lazily constructs, autowires and registers the internal component."
shared Map<
		String,
		Map<InterfaceDeclaration,
			JContainer()
				(ClassDeclaration,
				String,
				Anything(String,Object),
				Object(String,ClassDeclaration)) |
			JFrame()
				(ClassDeclaration,
				String,
				Anything(String,Object),
				Object(String,ClassDeclaration)) |
			LayoutManager()
				(ClassDeclaration,
				String,
				Anything(String,Object),
				Object(String,ClassDeclaration)) |
			EventListener()
				(ClassDeclaration,
				String,
				Anything(String,Object),
				Object(String,ClassDeclaration))>>
	autowiringFrameworkIntrnlCmpConstrConstrs = map({
		swingFramework -> map({
			`interface Component` -> (
				(ClassDeclaration decl,
				String cmpntName,
				void register(String name,Object obj),
				Object get(String name,ClassDeclaration decl)) {
				return () {
					value name = "``cmpntName``.val";
					register(
						name, 
						object extends GenericBeanDefinition() {
							setBeanClass(classForDeclaration(decl));
							lazyInit = false;
							abstract = false;
							autowireCandidate = true;
							scope = "singleton";
					});
					log.debug("Internal Component '``name``' definition registered.");
					assert (is JContainer intrnlCmp = get(name,decl));
					log.info("Internal Component '``name``' constructed.");
					return intrnlCmp;
				};
			}),
			`interface Container` -> (
				(ClassDeclaration decl,
				String cmpntName,
				void register(String name,Object obj),
				Object get(String name,ClassDeclaration decl)) {
				return () {
					value name = "``cmpntName``.val";
					register(
						name, 
						object extends GenericBeanDefinition() {
							setBeanClass(classForDeclaration(decl));
							lazyInit = false;
							abstract = false;
							autowireCandidate = true;
							scope = "singleton";
					});
					log.debug("Internal Component '``name``' definition registered.");
					assert (is JContainer intrnlCmp = get(name,decl));
					log.info("Internal Component '``name``' constructed.");
					return intrnlCmp;
				};
			}),
			`interface Window` -> (
				(ClassDeclaration decl,
				String cmpntName,
				void register(String name,Object obj),
				Object get(String name,ClassDeclaration decl)) {
				return () {
					value name = "``cmpntName``.val";
					register(
						name, 
						object extends GenericBeanDefinition() {
							setBeanClass(classForDeclaration(decl));
							lazyInit = false;
							abstract = false;
							autowireCandidate = true;
							scope = "singleton";
					});
					log.debug("Internal Component '``name``' definition registered.");
					assert (is JFrame intrnlCmp = get(name,decl));
					log.info("Internal Component '``name``' constructed.");
					return intrnlCmp;
				};
			}),
			`interface Layout` -> (
				(ClassDeclaration decl,
				String cmpntName,
				void register(String name,Object obj),
				Object get(String name,ClassDeclaration decl)) {
				return () {
					value name = "``cmpntName``.val";
					register(
						name, 
						object extends GenericBeanDefinition() {
							setBeanClass(classForDeclaration(decl));
							lazyInit = false;
							abstract = false;
							autowireCandidate = true;
							scope = "singleton";
					});
					log.debug("Internal Component '``name``' definition registered.");
					assert (is LayoutManager intrnlCmp = get(name,decl));
					log.info("Internal Component '``name``' constructed.");
					return intrnlCmp;
				};
			}),
			`interface Listener` -> (
				(ClassDeclaration decl,
				String cmpntName,
				void register(String name,Object obj),
				Object get(String name,ClassDeclaration decl)) {
				return () {
					value name = "``cmpntName``.val";
					register(
						name, 
						object extends GenericBeanDefinition() {
							setBeanClass(classForDeclaration(decl));
							lazyInit = false;
							abstract = false;
							autowireCandidate = true;
							scope = "singleton";
					});
					log.debug("Internal Component '``name``' definition registered.");
					assert (is EventListener intrnlCmp = get(name,decl));
					log.info("Internal Component '``name``' constructed.");
					return intrnlCmp;
				};
			})
		})
});
