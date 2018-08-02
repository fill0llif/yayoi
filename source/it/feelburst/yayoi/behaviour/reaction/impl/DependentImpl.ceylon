import it.feelburst.yayoi.behaviour.reaction {
	Dependent,
	Independent
}
shared class DependentImpl(
	shared actual Independent independent)
		satisfies Dependent {
	shared actual void awaitIndependent() {
		try(independent.lock) {
			independent.doneExecuting.await();
		}
	}
}