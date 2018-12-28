import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.marker {
	ComponentAnnotation,
	ContainerAnnotation,
	WindowAnnotation,
	ListenerAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation,
	LookAndFeelAnnotation,
	CollectionAnnotation,
	CollectValueAnnotation,
	RemoveValueAnnotation
}
shared sealed interface AnnotationReader {
	"Get a component annotation if it is"
	shared formal
		ComponentAnnotation|ContainerAnnotation|CollectionAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Get an action annotation if it is"
	shared formal DoLayoutAnnotation? action(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Get a setting annotation if it is"
	shared formal LookAndFeelAnnotation|CollectValueAnnotation|RemoveValueAnnotation? 
		setting(ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
}
