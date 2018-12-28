import it.feelburst.yayoi.behaviour.reaction {
	Dependent,
	Independent
}
shared final class DependentImpl(
	shared actual Independent independent)
		satisfies Dependent {
	shared actual void awaitIndependent() {
		try(independent.lock) {
			independent.doneExecuting.await();
		}
	}
}
