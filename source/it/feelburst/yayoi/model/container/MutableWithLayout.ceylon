import java.awt {
	LayoutManager
}
shared interface MutableWithLayout<Type=LayoutManager>
	satisfies WithLayout<Type>&WithLayoutMutator<Type>
	given Type satisfies LayoutManager {
}