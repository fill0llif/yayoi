import it.feelburst.yayoi.behaviour.reaction {
	Independent
}
import it.feelburst.yayoi.model.concurrent {
	Lock
}
import java.util.concurrent.locks {
	Condition
}
shared final class IndependentImpl()
		satisfies Independent {
	shared actual Lock lock = Lock();
	shared actual Condition doneExecuting = lock.newCondition();
	shared actual void signalDependent() {
		try(lock) {
			doneExecuting.signal();
		}
	}
}
