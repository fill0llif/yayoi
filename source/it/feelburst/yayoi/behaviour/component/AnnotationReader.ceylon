import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	Action
}
import it.feelburst.yayoi.marker {
	ComponentAnnotation,
	ContainerAnnotation,
	WindowAnnotation,
	ListenerAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation,
	SetLookAndFeelAnnotation
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
"Annotation checker"
see(
	`interface Component`,
	`interface Container`,
	`interface Window`,
	`interface Listener`,
	`interface Layout`,
	`interface Action`)
shared sealed interface AnnotationReader {
	"Get a component annotation if it is"
	shared formal
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Get an action annotation if it is"
	shared formal DoLayoutAnnotation|SetLookAndFeelAnnotation? action(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
}
