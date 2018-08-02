import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
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

"Components by model"
shared Map<ClassDeclaration,InterfaceDeclaration> modelsComponents = map({
	`class ComponentAnnotation` -> `interface Component`,
	`class ContainerAnnotation` -> `interface Container`,
	`class WindowAnnotation` -> `interface Window`,
	`class LayoutAnnotation` -> `interface Layout`,
	`class ListenerAnnotation` -> `interface Listener`,
	`class DoLayoutAnnotation` -> `interface LayoutAction`
});
