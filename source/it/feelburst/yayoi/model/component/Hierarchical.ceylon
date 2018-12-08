import it.feelburst.yayoi.model.container {

	AbstractContainer
}
"A component of a tree"
shared sealed interface Hierarchical {
	"Component parent"
	shared formal variable AbstractContainer? parent;
	"Component root"
	shared default AbstractContainer? root {
		variable value prnet = parent;
		while(is AbstractContainer prnt = prnet) {
			prnet = prnt.parent;
		}
		return prnet;
	}
}