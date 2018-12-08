import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	ClassDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	NestableDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction,
	LookAndFeelAction
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
	Types {
		classForType
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

shared abstract class Framework(shared String name) {
	shared formal ComponentConstructor componentConstructor(
		InterfaceDeclaration constrIntr);
	shared formal ActionConstructor actionConstructor(
		InterfaceDeclaration constrIntr);
	shared formal ClassDeclaration defaultWindowClosingListener();
}

shared interface Constructor<Type,Decl,Context>
	given Type satisfies Object
	given Decl satisfies NestableDeclaration {
	shared formal Type construct(
		String name,
		Decl decl,
		Context context);
}

shared interface ComponentConstructor
	satisfies Constructor<
		Component<Object>|
		Container<Object,Object>|
		Window<Object>|
		Layout<Object>|
		Listener<Object>,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration,
		AnnotationConfigApplicationContext> {
			
	shared Anything(Object) publishEventByContext(
		AnnotationConfigApplicationContext context) =>
		(Object event) =>
			let (executorService = context.getBean(classForType<ExecutorService>()))
			executorService.execute(() =>
				context.publishEvent(event));
	
}

shared interface ActionConstructor
	satisfies Constructor<
		LayoutAction|LookAndFeelAction,
		FunctionDeclaration,
		ApplicationContext> {}
