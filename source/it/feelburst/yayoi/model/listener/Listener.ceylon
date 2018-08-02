import it.feelburst.yayoi.model {
	Source,
	Named
}

import java.util {
	EventListener
}
"A listener that listens to a component event"
shared interface Listener<Lstnr=EventListener>
	satisfies Named&Source<Lstnr>
	given Lstnr satisfies EventListener {
}