import it.feelburst.yayoi.model {
	Source,
	Reactor
}
import it.feelburst.yayoi.model.component {
	Hierarchical
}

import java.awt {
	JContainer=Container,
	LayoutManager
}

"A container that can be rendered on screen within a container
 and that can render its components using a layout manager"
shared interface Container<out Type=JContainer,LayoutType=LayoutManager>
	satisfies
		AbstractContainer&
		Hierarchical&
		MutableWithLayout<LayoutType>&
		Source<Type>&
		Reactor
	given Type satisfies JContainer
	given LayoutType satisfies LayoutManager {}