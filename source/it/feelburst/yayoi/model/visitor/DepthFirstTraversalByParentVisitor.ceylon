import ceylon.interop.java {
	CeylonCollection
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

import java.lang {
	Types {
		classForType
	}
}

import org.springframework.context {
	ApplicationContext
}
shared final class DepthFirstTraversalByParentVisitor(
	ApplicationContext context)
	extends LateDependentVisitor() {
	
	value components = CeylonCollection(
		context
		.getBeansOfType(classForType<AbstractComponent>())
		.values());
	
	shared {AbstractComponent*} children(AbstractCollection clt) =>
		components
		.filter((AbstractComponent cmp) =>
			if (exists prt = cmp.parent) then
				prt == clt
			else
				false);
	
	shared actual void visitComponent<Type>(Component<Type> visited) {
		visitor.visitComponent(visited);
	}
	shared actual void visitContainer<Type>(
		Container<Type> visited) {
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
	
	void visitAbstractCollection(AbstractCollection clt) =>
		children(clt)
		.each((AbstractComponent cmpnt) {
			if (is Container<Object> cmpnt) {
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
