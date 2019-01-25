import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Named
}

shared final sealed annotation class SizeAnnotation(
	shared Integer width,
	shared Integer height,
	shared actual Integer order = 5)
	satisfies
		OptionalAnnotation<
			SizeAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class LocationAnnotation(
	shared Integer x, 
	shared Integer y,
	shared actual Integer order = 4)
	satisfies
		OptionalAnnotation<
			LocationAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class CenteredAnnotation(
	shared actual Integer order = 4)
	satisfies
		OptionalAnnotation<
			CenteredAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class ParentAnnotation(
	shared actual String name,
	shared actual String pckg = "",
	shared actual Integer order = 1)
	satisfies
		OptionalAnnotation<
			ParentAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Named&
		PackageDependent&
		Order {}

shared final sealed annotation class ExitOnCloseAnnotation(
	shared actual Integer order = 6)
	satisfies
		OptionalAnnotation<
			ExitOnCloseAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class DisposeOnCloseAnnotation(
	shared actual Integer order = 6)
	satisfies
		OptionalAnnotation<
			DisposeOnCloseAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class HideOnCloseAnnotation(
	shared actual Integer order = 6)
	satisfies
		OptionalAnnotation<
			HideOnCloseAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {}

shared final sealed annotation class WithLayoutAnnotation(
	shared actual String name,
	shared actual String pckg = "",
	shared actual Integer order = 2)
	satisfies
		OptionalAnnotation<
			WithLayoutAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Named&
		PackageDependent&
		Order {}

shared final sealed annotation class ListenableAnnotation(
	shared actual String name,
	shared actual String pckg = "",
	shared actual Integer order = 6)
	satisfies
		SequencedAnnotation<
			ListenableAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Named&
		PackageDependent&
		Order {}

shared final sealed annotation class CollectAnnotation(
	shared actual Integer order = 3)
	satisfies
		OptionalAnnotation<
			CollectAnnotation,
			FunctionDeclaration>&
		Order {}

shared annotation SizeAnnotation size(
	Integer width, 
	Integer height) =>
	SizeAnnotation(width, height);

shared annotation LocationAnnotation location(
	Integer x, 
	Integer y) =>
	LocationAnnotation(x, y);

shared annotation CenteredAnnotation centered() =>
	CenteredAnnotation();

shared annotation ParentAnnotation parent(
	String name,
	String pckg = "") =>
	ParentAnnotation(name, pckg);

shared annotation ExitOnCloseAnnotation exitOnClose() =>
	ExitOnCloseAnnotation();

shared annotation DisposeOnCloseAnnotation disposeOnClose() =>
	DisposeOnCloseAnnotation();

shared annotation HideOnCloseAnnotation hideOnClose() =>
	HideOnCloseAnnotation();

shared annotation WithLayoutAnnotation withLayout(
	String layout, 
	String pckg = "") =>
	WithLayoutAnnotation(layout, pckg);

shared annotation ListenableAnnotation listenable(
	String listener,
	String pckg = "") =>
	ListenableAnnotation(listener, pckg);
