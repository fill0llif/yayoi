import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container
}
import it.feelburst.yayoi.model.window {
	Window
}
shared interface Visitor {
	shared formal void visitComponent<Type>(
		Component<Type> visited);
	shared formal void visitContainer<Type,LayoutType>(
		Container<Type,LayoutType> visited);
	shared formal void visitWindow<Type>(
		Window<Type> visited);
}
