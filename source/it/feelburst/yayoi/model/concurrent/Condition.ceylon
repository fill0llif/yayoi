shared interface Condition {
	shared formal void await();
	shared formal void signal();
	shared formal void signalAll();
}
