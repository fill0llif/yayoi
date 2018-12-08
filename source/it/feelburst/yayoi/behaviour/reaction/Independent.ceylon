import it.feelburst.yayoi.model.concurrent {
	Lock
}

import java.util.concurrent.locks {
	Condition
}
"Independent property of reaction.
 An independent reaction on which another reaction depends
 (therefore must be used if the other reaction is a dependent reaction)."
see(`interface Reaction`,`interface Dependent`)
shared interface Independent {
	"Lock used by both the dependent and the independent reactions
	 to achieve dependent execution of the reaction"
	shared formal Lock lock;
	"Condition representing the execution of the independent reaction"
	shared formal Condition doneExecuting;
	"Signal the dependent reaction that this reaction is done executing"
	shared formal void signalDependent();
}
