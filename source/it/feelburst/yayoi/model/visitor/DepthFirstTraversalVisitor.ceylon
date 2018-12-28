import it.feelburst.yayoi.model {
	Stoppable
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection,
	Collection
}
import it.feelburst.yayoi.model.component {
	Component,
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	Container
}
import it.feelburst.yayoi.model.window {
	Window
}
shared final class DepthFirstTraversalVisitor()
	extends LateDependentVisitor()
	satisfies Stoppable {
	variable Boolean visiting = true;
	shared actual void visitComponent<Type>(Component<Type> visited) {
		visitor.visitComponent(visited);
	}
	shared actual void visitContainer<Type,LayoutType>(
		Container<Type,LayoutType> visited) {
		visitor.visitContainer(visited);
		visitAbstractCollection(visited);
	}
	shared actual void visitCollection<Type>(Collection<Type> visited) {
		visitor.visitCollection(visited);
		visitAbstractCollection(visited);
	}
	shared actual void visitWindow<Type>(Window<Type> visited) {
		visitor.visitWindow(visited);
		visitAbstractCollection(visited);
	}
	
	shared actual void stop() =>
		visiting = false;
	
	void visitAbstractCollection(AbstractCollection clt) {
		if (visiting) {
			clt.items.each((AbstractComponent cmpnt) {
				if (is Container<Object,Object> cmpnt) {
					visitContainer(cmpnt);
				}
				else if (is Collection<Object> cmpnt) {
					visitCollection(cmpnt);
				}
				else {
					assert (is Component<Object> cmpnt);
					visitComponent(cmpnt);
				}
			});
		}
	}
}
