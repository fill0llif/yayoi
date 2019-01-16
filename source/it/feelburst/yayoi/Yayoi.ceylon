import ceylon.interop.java {
	CeylonCollection
}
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
import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Dependent
}
import it.feelburst.yayoi.marker {
	YayoiAnnotation,
	FrameworkAnnotation
}
import it.feelburst.yayoi.model {
	Reactor,
	Framework
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.collection {
	Collection
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
	Types {
		classForType,
		classForDeclaration
	},
	Runtime {
		runtime
	},
	Thread
}
import java.util.concurrent {
	ExecutorService
}

import org.springframework.beans.factory.support {
	GenericBeanDefinition
}
import org.springframework.context.annotation {
	AnnotationConfigApplicationContext
}

"Manage application startup and shutdown, register components,
 execute reactions and actions"
see(
	`interface Component`,
	`interface Container`,
	`interface Collection`,
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
	assert (exists frmwrkAnn = annotations(`FrameworkAnnotation`, appType));
	value framework = frmwrkAnn.framework;
	
	{Package+} packages(Framework frmwrk) =>
		frmwrk.packages.chain(appAnn.basePackages);
	
	shared actual void run() {
		addLogWriter(writeLog);
		configLogger();
		log.info("Application startup...");
		value context = AnnotationConfigApplicationContext();
		value frmwrkImpl = registerFrameworkImpl(context);
		log.info("Framework implementation '``framework``' found.");
		context.register(classForType<Conf>());
		context.refresh();
		addShutdownHooks(context);
		log.info("Registering components...");
		packages(frmwrkImpl)
		.each((Package pckg) =>
			log.info("Base package '``pckg``' found."));
		registerComponents(context,frmwrkImpl);
		frmwrkImpl.setLookAndFeel(context);
		log.info("Executing reactions...");
		executeReactions(context);
		log.info("Executing actions...");
		executeActions(context);
		log.info("Registering app...");
		value invokeApp = registerApp(context);
		log.info("Running app...");
		invokeApp();
		log.info("Waiting for window to close...");
		frmwrkImpl.waitForWindowsToClose();
		shutdownExecutors(context);
	}
	
	Framework registerFrameworkImpl(AnnotationConfigApplicationContext context) {
		try {
			value frmwrk = this.framework.apply<Framework>().get();
			context.beanFactory
				.registerSingleton("frameworkImpl", frmwrk);
			return frmwrk;
		}
		catch (Exception e) {
			value message =
				"Cannot startup application due to the following error: ``e.message``.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	void addShutdownHooks(AnnotationConfigApplicationContext context) {
		runtime.addShutdownHook(Thread(object satisfies Runnable {
			shared actual void run() {
				log.info("Application shutting down...");
				context.close();
			}
		}));
	}
	
	void registerComponents(
		AnnotationConfigApplicationContext context,
		Framework frmwrk) =>
		context
		.getBean(classForType<ComponentRegistry>())
		.registerByPackages(*packages(frmwrk));
	
	void executeReactions(AnnotationConfigApplicationContext context) {
		value executorService = context
			.getBean(classForType<ExecutorService>());
		CeylonCollection(context
			.getBeansOfType(classForType<Reactor>())
			.values())
		.flatMap((Reactor reactor) =>
			reactor.reactions<>())
		.sort((Reaction<> x, Reaction<> y) =>
			x <=> y)
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
					"``e.message``",e);
			}
		});
	}
	
	void executeActions(AnnotationConfigApplicationContext context) =>
		CeylonCollection(context
			.getBeansOfType(classForType<Action>())
			.values())
		.each((Action action) {
			try {
				action.execute();
			}
			catch (Exception e) {
				log.error(
					"Action '``classDeclaration(action).name``' on declaration " +
					"'``action.decl``' failed executing due to the following error: " +
					"``e.message``",e);
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
		value appInstance =
			context.getBean(classForDeclaration(appType));
		if (is Runnable appInstance) {
			value executorService = context
				.getBean(classForType<ExecutorService>());
			return () =>
				executorService.execute(appInstance);
		}
		else {
			value message =
				"Cannot startup application. '``appInstance``' is not a runnable application.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	void shutdownExecutors(AnnotationConfigApplicationContext context) {
		value executorService = context
				.getBean(classForType<ExecutorService>());
		executorService.shutdown();
	}
	
}
