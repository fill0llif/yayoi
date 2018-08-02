import java.awt {
	LayoutManager
}
shared interface WithLayout<out Type=LayoutManager>
	given Type satisfies LayoutManager {
	shared formal Layout<Type>? layout;
}