import it.feelburst.yayoi.model.component {
	Component,
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	Container,
	AbstractContainer
}
import it.feelburst.yayoi.model.window {
	Window
}
shared class TraversalVisitor(Visitor visitor) satisfies Visitor {
	shared actual void visitComponent<Type>(Component<Type> visited) {
		visitor.visitComponent(visited);
	}
	shared actual void visitContainer<Type,LayoutType>(
		Container<Type,LayoutType> visited) {
		visitor.visitContainer(visited);
		visitAbstractContainer(visited);
	}
	shared actual void visitWindow<Type>(Window<Type> visited) {
		visitor.visitWindow(visited);
		visitAbstractContainer(visited);
	}
	
	void visitAbstractContainer(AbstractContainer cntr) =>
		cntr.components.each((AbstractComponent cmpnt) {
			if (is Container<Object,Object> cmpnt) {
				visitContainer(cmpnt);
			}
			else {
				assert (is Component<Object> cmpnt);
				visitComponent(cmpnt);
			}
		});
	
}
