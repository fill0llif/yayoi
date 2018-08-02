
import it.feelburst.yayoi.model.container {

	AbstractContainer
}
"A component of a tree"
shared interface Hierarchical {
	"Component parent"
	shared formal AbstractContainer? parent;
	shared formal void setParent(AbstractContainer? parent);
	"Component root"
	shared default AbstractContainer? root {
		variable value prnet = parent;
		while(is AbstractContainer prnt = prnet) {
			prnet = prnt.parent;
		}
		return prnet;
	}
}