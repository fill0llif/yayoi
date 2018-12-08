"A dependent reaction"
shared interface DependentReaction<Cmpnt>
	satisfies Reaction<Cmpnt>&Dependent
	given Cmpnt satisfies Object {
	shared formal Reaction<Cmpnt> reaction;
	shared default actual Cmpnt cmp => reaction.cmp;
	shared default actual Annotation ann => reaction.ann;
}