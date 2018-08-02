import it.feelburst.yayoi.model {
	Source,
	Named
}

import java.awt {
	LayoutManager
}
"A layout that defines how the components of a container are
 rendered on screen"
shared interface Layout<out Type=LayoutManager>
	satisfies Named&Source<Type>
	given Type satisfies LayoutManager {}