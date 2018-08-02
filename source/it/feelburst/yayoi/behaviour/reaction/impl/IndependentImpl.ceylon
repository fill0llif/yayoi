import it.feelburst.yayoi.behaviour.reaction {
	Independent
}
import it.feelburst.yayoi.model.concurrent {
	Condition,
	Lock
}
shared class IndependentImpl()
		satisfies Independent {
	shared actual Lock lock = Lock();
	shared actual Condition doneExecuting = lock.newCondition();
	shared actual void signalDependent() {
		try(lock) {
			doneExecuting.signal();
		}
	}
}