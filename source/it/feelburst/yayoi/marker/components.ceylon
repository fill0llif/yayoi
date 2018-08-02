import it.feelburst.yayoi {

	ComponentDecl
}
shared final sealed annotation class ComponentAnnotation()
		satisfies OptionalAnnotation<ComponentAnnotation,ComponentDecl> {}

shared final sealed annotation class ContainerAnnotation()
		satisfies OptionalAnnotation<ContainerAnnotation,ComponentDecl> {}

shared final sealed annotation class WindowAnnotation()
		satisfies OptionalAnnotation<WindowAnnotation,ComponentDecl> {}

shared final sealed annotation class LayoutAnnotation()
		satisfies OptionalAnnotation<LayoutAnnotation,ComponentDecl> {}

shared final sealed annotation class ListenerAnnotation()
		satisfies OptionalAnnotation<ListenerAnnotation,ComponentDecl> {}

shared annotation ComponentAnnotation component() =>
		ComponentAnnotation();

shared annotation ContainerAnnotation container() =>
		ContainerAnnotation();

shared annotation WindowAnnotation window() =>
		WindowAnnotation();

shared annotation LayoutAnnotation layout() =>
		LayoutAnnotation();

shared annotation ListenerAnnotation listener() =>
		ListenerAnnotation();