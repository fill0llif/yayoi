import ceylon.language.meta {
	annotations,
	classDeclaration
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	Package
}
import ceylon.logging {
	addLogWriter,
	Priority,
	Category
}

import it.feelburst.yayoi.behaviour.action {
	Action
}
import it.feelburst.yayoi.behaviour.component {
	ComponentRegistry
}
import it.feelburst.yayoi.behaviour.component.impl {
	ActionContext,
	ReactorContext
}
import it.feelburst.yayoi.behaviour.listener.model {
	ShutdownRequested
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Dependent
}
import it.feelburst.yayoi.marker {
	YayoiAnnotation
}
import it.feelburst.yayoi.model {
	Reactor,
	Framework
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
import it.feelburst.yayoi.model.window {
	Window
}

import java.lang {
	Runnable,
	Thread {
		currentThread
	},
	Types {
		classForType,
		classForDeclaration
	}
}
import java.util.concurrent {
	ExecutorService
}

import javax.swing {
	SwingUtilities {
		invokeAndWait
	}
}

import org.springframework.beans.factory.support {
	GenericBeanDefinition
}
import org.springframework.context {
	ApplicationEventPublisher
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}

"Manage application startup and shutdown, register components,
 execute reactions and actions"
see(
	`interface Component`,
	`interface Container`,
	`interface Window`,
	`interface Listener`,
	`interface Layout`)
by("Filippo Vitanza")
shared final class Yayoi(
	"User defined app declaration"
	ClassDeclaration appType,
	"User defined logger configuration"
	void configLogger() =>
		noop(),
	"User defined logger writer"
	void writeLog(
		Priority priority, Category category,
		String message, Throwable? throwable) =>
		package.defaultWriteLog(priority, category, message, throwable))
	satisfies Runnable {
	
	assert (exists appAnn = annotations(`YayoiAnnotation`, appType));
	value basePackages = appAnn.basePackages;
	value frameworkImpl = appAnn.frameworkImpl;
	
	shared actual void run() {
		addLogWriter(writeLog);
		configLogger();
		log.info("Application startup...");
		value context = AnnotationConfigApplicationContext();
		registerFrameworkImpl(context);
		log.info("Framework implementation '``frameworkImpl``' found.");
		context.register(classForType<Conf>());
		context.refresh();
		log.info("Registering components...");
		basePackages.each((Package pckg) =>
			log.info("Base package '``pckg``' found."));
		registerComponents(context);
		log.info("Executing reactions...");
		executeReactions(context);
		log.info("Executing actions...");
		executeActions(context);
		log.info("Registering app...");
		value invokeApp = registerApp(context);
		log.info("Running app...");
		invokeApp();
		log.info("Waiting for window to close...");
		waitForWindowsToClose();
		value eventPublisher = context
			.getBean(classForType<ApplicationEventPublisher>());
		eventPublisher.publishEvent(ShutdownRequested());
	}
	
	void registerFrameworkImpl(AnnotationConfigApplicationContext context) {
		assert (is Framework frameworkImpl = this.frameworkImpl.get());
		context.beanFactory
			.registerSingleton("frameworkImpl", frameworkImpl);
	}
	
	void registerComponents(AnnotationConfigApplicationContext context) =>
		context
		.getBean(classForType<ComponentRegistry>())
		.registerByPackages(*basePackages);
	
	void executeReactions(AnnotationConfigApplicationContext context) {
		value executorService = context
			.getBean(classForType<ExecutorService>());
		context
		.getBean("reactorContext",classForType<ReactorContext>())
		.values()
		.each((String name) =>
			let (reactor = context.getBean(name,classForType<Reactor>()))
			reactor
			.reactions<>()
			.each((Reaction<> reaction) {
				try {
					if (is Dependent reaction) {
						executorService.submit(() {
							reaction.awaitIndependent();
							reaction.execute();
						});
					}
					else {
						reaction.execute();
					}
				}
				catch (Exception e) {
					log.error(
						"Reaction '``classDeclaration(reaction).name``' on component " +
						"'``reaction.cmp``' failed executing due to the following error: " +
						"``e.message``");
				}
			}));
	}
	
	void executeActions(AnnotationConfigApplicationContext context) =>
		context.getBean("actionContext",classForType<ActionContext>())
		.values()
		.each((String name) {
			value action = context.getBean(name,classForType<Action>());
			try {
				action.execute();
			}
			catch (Exception e) {
				log.error(
					"Action '``classDeclaration(action).name``' on declaration " +
					"'``action.decl``' failed executing due to the following error: " +
					"``e.message``");
			}
		});
	
	Anything() registerApp(AnnotationConfigApplicationContext context) {
		context.registerBeanDefinition("application", object extends GenericBeanDefinition() {
			setBeanClass(classForDeclaration(appType));
			lazyInit = false;
			abstract = false;
			autowireCandidate = true;
			scope = "singleton";
		});
		assert (is Runnable appInstance =
			context.getBean(classForDeclaration(appType)));
		value executorService = context
			.getBean(classForType<ExecutorService>());
		return () =>
			executorService.execute(appInstance);
	}
	
	void waitForWindowsToClose() =>
		awtThread.join();
	
	Thread awtThread {
		variable Thread? awtThread = null;
		invokeAndWait(() =>
			awtThread = currentThread());
		assert (exists thread = awtThread);
		return thread;
	}
	
}
