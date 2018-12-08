shared sealed interface WithLayout<Type>
	given Type satisfies Object {
	shared formal Layout<Type>? layout;
}
