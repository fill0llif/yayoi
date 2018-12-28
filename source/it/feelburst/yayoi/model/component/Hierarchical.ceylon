import it.feelburst.yayoi.model.collection {

	AbstractCollection
}
"A component of a tree"
shared sealed interface Hierarchical {
	"Component parent"
	shared formal variable AbstractCollection? parent;
	"Component root"
	shared default AbstractCollection? root {
		variable value prnet = parent;
		while(is AbstractCollection prnt = prnet) {
			prnet = prnt.parent;
		}
		return prnet;
	}
}
