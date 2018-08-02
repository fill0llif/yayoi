"Dependent property of reaction.
 A reaction may depend on another reaction (on the same component)."
see(`interface Reaction`,`interface Independent`)
shared interface Dependent {
	"A reaction on which this reaction depends on"
	shared formal Independent independent;
	"Await the reaction on which this reaction depends on to be done executing"
	shared formal void awaitIndependent();
}