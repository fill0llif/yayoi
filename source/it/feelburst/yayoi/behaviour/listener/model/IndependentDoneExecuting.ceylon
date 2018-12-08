import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"An event that reports an independent reaction is done executing"
shared class IndependentDoneExecuting(
	shared AbstractComponent source,
	shared Boolean isIndependent(Reaction<Object> rctn)) {}
