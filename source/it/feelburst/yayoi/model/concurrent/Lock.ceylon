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
	shared Condition newCondition() =>
		object satisfies Condition {
			JCondition condition = reentrantLock.newCondition();
			shared actual void await() =>
				condition.await();
			shared actual void signal() =>
				condition.signal();
			shared actual void signalAll() =>
				condition.signalAll();
		};
	shared actual String string =>
		reentrantLock.string;
}
