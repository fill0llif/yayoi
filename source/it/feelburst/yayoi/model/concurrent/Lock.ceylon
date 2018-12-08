import java.util.concurrent.locks {
	JReentrantLock=ReentrantLock,
	JCondition=Condition
}

shared final class Lock(Boolean fair = false) satisfies Obtainable {
	JReentrantLock reentrantLock = JReentrantLock(fair);
	shared actual void obtain() =>
		reentrantLock.lock();
	shared actual void release(Throwable? error) {
		reentrantLock.unlock();
		if (exists e = error) {
			throw e;
		}
	}
	shared JCondition newCondition() =>
		reentrantLock.newCondition();
	shared actual String string =>
		reentrantLock.string;
}
