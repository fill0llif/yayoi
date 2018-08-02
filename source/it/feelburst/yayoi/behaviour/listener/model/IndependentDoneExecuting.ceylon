import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports an independent reaction is done executing"
shared class IndependentDoneExecuting(
	shared actual AbstractComponent source,
	shared Boolean isIndependent(Reaction<Object> rctn))
	extends ApplicationEvent(source) {}