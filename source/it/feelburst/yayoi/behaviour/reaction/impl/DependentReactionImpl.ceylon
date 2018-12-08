import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Independent,
	DependentReaction
}

shared class DependentReactionImpl<Cmpnt>(
	shared actual Reaction<Cmpnt> reaction,
	shared actual Independent independent)
	satisfies DependentReaction<Cmpnt>
	given Cmpnt satisfies Object {
	
	value dependentImpl = DependentImpl(independent);
	
	shared actual void awaitIndependent() =>
		dependentImpl.awaitIndependent();
	
	shared actual void execute() =>
		reaction.execute();
}
