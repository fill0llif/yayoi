shared sealed interface MutableWithLayout<Type>
	satisfies WithLayout<Type>&WithLayoutMutator<Type>
	given Type satisfies Object {}
