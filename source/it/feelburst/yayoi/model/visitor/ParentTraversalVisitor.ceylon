import it.feelburst.yayoi.model.collection {
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
shared final class ParentTraversalVisitor(Visitor visitor)
	satisfies Visitor {
	
	shared actual void visitComponent<Type>(Component<Type> visited) {
		visitor.visitComponent(visited);
		visitAbstractCollectionParent(visited);
	}
	
	shared actual void visitCollection<Type>(Collection<Type> visited) {
		visitor.visitCollection(visited);
		visitAbstractCollectionParent(visited);
	}
	
	shared actual void visitContainer<Type>(Container<Type> visited) {
		visitor.visitContainer(visited);
		visitAbstractCollectionParent(visited);
	}
	
	shared actual void visitWindow<Type>(Window<Type> visited) {
		visitor.visitWindow(visited);
	}
	
	void visitAbstractCollectionParent(AbstractComponent cltPrnt) {
		if (exists parent = cltPrnt.parent) {
			if (is Container<Object> parent) {
				visitContainer(parent);
			}
			else if (is Collection<Object> parent) {
				visitCollection(parent);
			}
			else {
				assert (is Window<Object> parent);
				visitWindow(parent);
			}
		}
	}
	
}