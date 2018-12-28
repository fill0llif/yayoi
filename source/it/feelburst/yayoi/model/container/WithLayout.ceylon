shared sealed interface WithLayout<out Type>
	given Type satisfies Object {
	shared formal Layout<Type>? layout;
}
