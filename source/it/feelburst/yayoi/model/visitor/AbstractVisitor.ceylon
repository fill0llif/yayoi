import it.feelburst.yayoi.model.container {

	Container
}
import it.feelburst.yayoi.model.window {

	Window
}
import it.feelburst.yayoi.model.collection {

	Collection
}
import it.feelburst.yayoi.model.component {

	Component
}
shared abstract class AbstractVisitor()
	satisfies Visitor {
	shared default actual void visitComponent<Type>(
		Component<Type> visited) {}
	shared default actual void visitContainer<Type,LayoutType>(
		Container<Type,LayoutType> visited) {}
	shared default actual void visitCollection<Type>(
		Collection<Type> visited) {}
	shared default actual void visitWindow<Type>(
		Window<Type> visited) {}
}