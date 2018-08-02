import it.feelburst.yayoi {
	ComponentDecl,
	ActionDecl
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
	LayoutAnnotation
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
shared interface AnnotationChecker {
	"Check if it's a component"
	shared formal
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(ComponentDecl decl);
	"Check if it's an action"
	shared formal DoLayoutAnnotation? action(ActionDecl decl);
}
