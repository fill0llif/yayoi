shared sealed interface WithLayoutMutator<in Type>
	given Type satisfies Object {
	shared formal void setLayout(Layout<Type>? layout);
}
