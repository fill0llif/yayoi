shared sealed interface WithLayoutMutator<Type>
	given Type satisfies Object {
	shared formal void setLayout(Layout<Type>? layout);
}
