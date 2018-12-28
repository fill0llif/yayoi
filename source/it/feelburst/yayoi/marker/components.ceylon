import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.collection {
	Collection
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}
shared final sealed annotation class ComponentAnnotation()
	satisfies OptionalAnnotation<
		ComponentAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Component`;
}

shared final sealed annotation class ContainerAnnotation()
	satisfies OptionalAnnotation<
		ContainerAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Container`;
}

shared final sealed annotation class CollectionAnnotation()
	satisfies OptionalAnnotation<
		CollectionAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Collection`;
}

shared final sealed annotation class WindowAnnotation()
	satisfies OptionalAnnotation<
		WindowAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Window`;
}

shared final sealed annotation class LayoutAnnotation()
	satisfies OptionalAnnotation<
		LayoutAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Layout`;
}

shared final sealed annotation class ListenerAnnotation()
	satisfies OptionalAnnotation<
		ListenerAnnotation,
		ClassDeclaration|FunctionDeclaration|ValueDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface Listener`;
}

shared annotation ComponentAnnotation component() =>
	ComponentAnnotation();

shared annotation ContainerAnnotation container() =>
	ContainerAnnotation();

shared annotation CollectionAnnotation collection() =>
	CollectionAnnotation();

shared annotation WindowAnnotation window() =>
	WindowAnnotation();

shared annotation LayoutAnnotation layout() =>
	LayoutAnnotation();

shared annotation ListenerAnnotation listener() =>
	ListenerAnnotation();
