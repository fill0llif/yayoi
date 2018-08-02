import java.awt {

	LayoutManager
}
shared interface WithLayoutMutator<in Type=LayoutManager>
	given Type satisfies LayoutManager {
	shared formal void setLayout(Layout<Type>? layout);
}