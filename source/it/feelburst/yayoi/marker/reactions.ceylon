import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
import ceylon.language.meta.model {
	Method,
	Attribute
}

import it.feelburst.yayoi.model {
	Named,
	Value,
	ComponentMutableMap
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent,
	Hierarchical
}
import it.feelburst.yayoi.model.container {
	WithLayoutMutator,
	Layout,
	Container
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}

shared final sealed annotation class SizeAnnotation(
	shared Integer width,
	shared Integer height,
	shared actual Integer order = 5)
	satisfies
		OptionalAnnotation<
			SizeAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {
	shared Method<AbstractComponent,Anything,Integer[2]> agent =>
		`AbstractComponent.setSize`;
}

shared final sealed annotation class LocationAnnotation(
	shared Integer x, 
	shared Integer y,
	shared actual Integer order = 4)
	satisfies
		OptionalAnnotation<
			LocationAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {
	shared Method<AbstractComponent,Anything,Integer[2]> agent =>
		`AbstractComponent.setLocation`;
}

shared final sealed annotation class CenteredAnnotation(
	shared actual Integer order = 4)
	satisfies
		OptionalAnnotation<
			CenteredAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {
	shared Method<AbstractComponent,Anything,[]> agent =>
		`AbstractComponent.center`;
}

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
		Order {
	shared Attribute<Hierarchical,AbstractCollection?,AbstractCollection?> agent =>
		`Hierarchical.parent`;
}

shared final sealed annotation class ExitOnCloseAnnotation(
	shared actual Integer order = 6)
	satisfies
		OptionalAnnotation<
			ExitOnCloseAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		Order {
	shared Method<Window<Object>,Anything,[]> agent =>
		`Window<Object>.setExitOnClose`;
}

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
		Order {
	shared Method<Container<Object,Object>,Anything,[Layout<Object>?]> agent =>
		`WithLayoutMutator<Object>.setLayout`;
}

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
		Order {
	shared Method<
		ComponentMutableMap<String,Listener<Object>>,
		Listener<Object>?,
		[Listener<Object>, Boolean=]> agent =>
		`ComponentMutableMap<String,Listener<Object>>.add`;
}

shared final sealed annotation class CollectAnnotation(
	shared actual Integer order = 3)
	satisfies
		OptionalAnnotation<
			CollectAnnotation,
			FunctionDeclaration>&
		Order {
	shared Method<AbstractCollection,
		<AbstractComponent&Value<Object>>?,
		[AbstractComponent&Value<Object>, Boolean=]> agent =>
		`AbstractCollection.add`;
}

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

shared annotation WithLayoutAnnotation withLayout(
	String layout, 
	String pckg = "") =>
	WithLayoutAnnotation(layout, pckg);

shared annotation ListenableAnnotation listenable(
	String listener,
	String pckg = "") =>
	ListenableAnnotation(listener, pckg);
