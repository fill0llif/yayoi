import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
import ceylon.language.meta.model {
	Method
}

import it.feelburst.yayoi.model.component {
	AbstractComponent,
	ComponentMutator
}
import it.feelburst.yayoi.model.container {
	AbstractContainer,
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
	shared actual Integer order = 1)
		satisfies
		OptionalAnnotation<
			SizeAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<AbstractComponent,Anything,Integer[2]>&Order {
	shared actual Method<AbstractComponent,Anything,Integer[2]> agentMdl =>
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
		ModelReaction<AbstractComponent,Anything,Integer[2]>&Order {
	shared actual Method<AbstractComponent,Anything,Integer[2]> agentMdl =>
		`AbstractComponent.setLocation`;
}

shared final sealed annotation class CenteredAnnotation(
	shared actual Integer order = 4)
		satisfies
		OptionalAnnotation<
			CenteredAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<AbstractComponent,Anything,[]>&Order {
	shared actual Method<AbstractComponent,Anything,[]> agentMdl =>
		`AbstractComponent.center`;
}

shared final sealed annotation class ParentAnnotation(
	shared String name,
	shared actual String pckg = "",
	shared actual Integer order = 3)
		satisfies
		OptionalAnnotation<
			ParentAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<ComponentMutator,Anything,[AbstractContainer]>&
		PackageDependent&Order {
	shared actual Method<ComponentMutator,Anything,[AbstractComponent]>  agentMdl =>
		`AbstractContainer.addComponent`;
}

shared final sealed annotation class ExitOnCloseAnnotation(
	shared actual Integer order = 5)
		satisfies
		OptionalAnnotation<
			ExitOnCloseAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<Window<Object>,Anything,[]>&Order {
	shared actual Method<Window<Object>,Anything,[]> agentMdl =>
		`Window<Object>.setExitOnClose`;
}

shared final sealed annotation class WithLayoutAnnotation(
	shared String layout,
	shared actual String pckg = "",
	shared actual Integer order = 2)
		satisfies
		OptionalAnnotation<
			WithLayoutAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<
			Container<Object,Object>,
			Anything,
			[Layout<Object>?]>&
		PackageDependent&
		Order {
	shared actual Method<Container<Object,Object>,Anything,[Layout<Object>?]> agentMdl =>
		`WithLayoutMutator<Object>.setLayout`;
}

shared final sealed annotation class OnActionPerformedAnnotation(
	shared String listener,
	shared actual String pckg = "",
	shared actual Integer order = 5)
		satisfies
		OptionalAnnotation<
			OnActionPerformedAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<AbstractComponent,Anything,[Listener<Object>]>&
		PackageDependent&
		Order {
	shared actual Method<AbstractComponent,Anything,[Listener<Object>]> agentMdl =>
		`AbstractComponent.addListener`;
}

shared final sealed annotation class WindowEventAnnotation(
	shared String listener,
	shared actual String pckg = "",
	shared actual Integer order = 5)
		satisfies
		OptionalAnnotation<
			WindowEventAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration>&
		ModelReaction<AbstractComponent,Anything,[Listener<Object>]>&
		PackageDependent&
		Order {
	shared actual Method<AbstractComponent,Anything,[Listener<Object>]> agentMdl =>
		`AbstractComponent.addListener`;
}

shared annotation SizeAnnotation size(
	Integer width, 
	Integer height, 
	Integer order = 1) =>
	SizeAnnotation(width, height, order);

shared annotation LocationAnnotation location(
	Integer x, 
	Integer y,
	Integer order = 4) =>
	LocationAnnotation(x, y, order);

shared annotation CenteredAnnotation centered(
	Integer order = 4) =>
	CenteredAnnotation(order);

shared annotation ParentAnnotation parent(
	String name,
	String pckg = "",
	Integer order = 3) =>
	ParentAnnotation(name, pckg, order);

shared annotation ExitOnCloseAnnotation exitOnClose(
	Integer order = 5) =>
		ExitOnCloseAnnotation(order);

shared annotation WithLayoutAnnotation withLayout(
	String layout, 
	String pckg = "",
	Integer order = 2) =>
	WithLayoutAnnotation(layout, pckg, order);

shared annotation OnActionPerformedAnnotation onActionPerformed(
	String listener,
	String pckg = "",
	Integer order = 5) =>
	OnActionPerformedAnnotation(listener, pckg, order);

shared annotation WindowEventAnnotation onWindowEvent(
	String listener, 
	String pckg = "",
	Integer order = 5) =>
	WindowEventAnnotation(listener, pckg, order);
