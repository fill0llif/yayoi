import it.feelburst.yayoi.model.component {

	Hierarchical
}
import it.feelburst.yayoi.model.container {

	AbstractContainer
}
shared class SwingHierarchical() satisfies Hierarchical {
	variable AbstractContainer? prnt = null;
	shared actual AbstractContainer? parent =>
		prnt;
	shared actual void setParent(AbstractContainer? parent) =>
		prnt = parent;
}