import ceylon.interop.java {
	javaClassFromDeclaration,
	javaString
}
import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
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
	ComponentRegister
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
	Reactor
}

import java.lang {
	Runnable,
	Thread {
		currentThread
	},
	Types {
		classForType
	}
}
import java.util.concurrent {
	ExecutorService
}

import javax.swing {
	SwingUtilities {
		invokeLater,
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
import it.feelburst.yayoi.model.component {

	Component
}
import it.feelburst.yayoi.model.container {

	Container,
	Layout
}
import it.feelburst.yayoi.model.window {

	Window
}
import it.feelburst.yayoi.model.listener {

	Listener
}

shared alias ComponentDecl =>
	ClassDeclaration|FunctionDeclaration|ValueDeclaration;
shared alias ActionDecl =>
	FunctionDeclaration;

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
		executeReaction(context);
		log.info("Executing actions...");
		executeAction(context);
		log.info("Registering app...");
		value appInstance = registerApp(context);
		log.info("Running app...");
		invokeApp(appInstance);
		log.info("Waiting for window to close...");
		waitForWindowsToClose();
		value eventPublisher = context
			.getBean(classForType<ApplicationEventPublisher>());
		eventPublisher.publishEvent(ShutdownRequested(this));
	}
	
	void registerFrameworkImpl(AnnotationConfigApplicationContext context) =>
		context.beanFactory
		.registerSingleton("frameworkImpl", javaString(frameworkImpl));
	
	void registerComponents(AnnotationConfigApplicationContext context) =>
		context
		.getBean(classForType<ComponentRegister>())
		.registerByPackages(*basePackages);
	
	void executeReaction(AnnotationConfigApplicationContext context) {
		value executorService = context
			.getBean(classForType<ExecutorService>());
		context
		.getBean("reactorContext",classForType<ReactorContext>())
		.values()
		.each((String name) =>
			let (reactor = context.getBean(name,classForType<Reactor>()))
			reactor
			.reactions
			.each((Reaction<> reaction) {
				if (is Dependent reaction) {
					executorService.execute(() {
						reaction.awaitIndependent();
						reaction.execute();
					});
				}
				else {
					reaction.execute();
				}
			}));
	}
	
	void executeAction(AnnotationConfigApplicationContext context) =>
		context.getBean("actionContext",classForType<ActionContext>())
		.values()
		.each((String name) =>
			let (action = context.getBean(name,classForType<Action>()))
			action.execute());
	
	Runnable registerApp(AnnotationConfigApplicationContext context) {
		context.registerBeanDefinition("application", object extends GenericBeanDefinition() {
			setBeanClass(javaClassFromDeclaration(appType));
			lazyInit = false;
			abstract = false;
			autowireCandidate = true;
			scope = "singleton";
		});
		assert (is Runnable appInstance =
			context.getBean(javaClassFromDeclaration(appType)));
		return appInstance;
	}
	
	void invokeApp(Runnable appInstance) =>
		invokeLater(appInstance);
	
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
