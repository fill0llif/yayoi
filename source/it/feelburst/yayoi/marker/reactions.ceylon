import ceylon.language.meta.model {
	Method
}

import it.feelburst.yayoi {
	ComponentDecl
}
import it.feelburst.yayoi.model.component {
	AbstractComponent,
	Hierarchical
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

import java.awt {
	LayoutManager,
	JContainer=Container
}
import java.util {
	EventListener
}

import javax.swing {
	JFrame
}

shared final sealed annotation class TitleAnnotation(
	shared String val,
	shared actual Integer order = 4)
		satisfies
OptionalAnnotation<TitleAnnotation,ComponentDecl>&
		ModelReaction<Window<JFrame>,Anything,[String]>&Order {
	shared actual Method<Window<JFrame>,Anything,[String]> agentMdl =>
			`Window<JFrame>.setTitle`;
}

shared final sealed annotation class SizeAnnotation(
	shared Integer width,
	shared Integer height,
	shared actual Integer order = 1)
		satisfies
OptionalAnnotation<SizeAnnotation,ComponentDecl>&
		ModelReaction<AbstractComponent,Anything,Integer[2]>&Order {
	shared actual Method<AbstractComponent,Anything,Integer[2]> agentMdl =>
			`AbstractComponent.setSize`;
}

shared final sealed annotation class LocationAnnotation(
	shared Integer x, 
	shared Integer y,
	shared actual Integer order = 3)
		satisfies
OptionalAnnotation<LocationAnnotation,ComponentDecl>&
		ModelReaction<AbstractComponent,Anything,Integer[2]>&Order {
	shared actual Method<AbstractComponent,Anything,Integer[2]> agentMdl =>
			`AbstractComponent.setLocation`;
}

shared final sealed annotation class CenteredAnnotation(
	shared actual Integer order = 3)
		satisfies
OptionalAnnotation<CenteredAnnotation,ComponentDecl>&
		ModelReaction<AbstractComponent,Anything,[]>&Order {
	shared actual Method<AbstractComponent,Anything,[]> agentMdl =>
			`AbstractComponent.center`;
}

shared final sealed annotation class ParentAnnotation(
	shared String name,
	shared actual String pckg = "",
	shared actual Integer order = 2)
		satisfies
OptionalAnnotation<ParentAnnotation,ComponentDecl>&
		ModelReaction<Hierarchical,Anything,[AbstractContainer?]>&
		PackageDependent&Order {
	shared actual Method<Hierarchical,Anything,[AbstractContainer?]> agentMdl =>
			`Hierarchical.setParent`;
}

shared final sealed annotation class ExitOnCloseAnnotation(
	shared actual Integer order = 4)
		satisfies
OptionalAnnotation<ExitOnCloseAnnotation,ComponentDecl>&
		ModelReaction<Window<JFrame>,Anything,[]>&Order {
	shared actual Method<Window<JFrame>,Anything,[]> agentMdl =>
			`Window<JFrame>.setExitOnClose`;
}

shared final sealed annotation class OnActionPerformedAnnotation(
	shared String listener,
	shared actual String pckg = "",
	shared actual Integer order = 4)
		satisfies
		OptionalAnnotation<OnActionPerformedAnnotation,ComponentDecl>&
		ModelReaction<AbstractComponent,Anything,[Listener<EventListener>]>&
		PackageDependent&
		Order {
	shared actual Method<AbstractComponent,Anything,[Listener<EventListener>]> agentMdl =>
		`AbstractComponent.addListener`;
}

shared final sealed annotation class WithLayoutAnnotation(
	shared String layout,
	shared actual String pckg = "",
	shared actual Integer order = 4)
		satisfies
		OptionalAnnotation<WithLayoutAnnotation,ComponentDecl>&
		ModelReaction<
			Container<JContainer,LayoutManager>,
			Anything,
			[Layout<LayoutManager>?]>&
		PackageDependent&
		Order {
	shared actual Method<Container<JContainer,LayoutManager>,Anything,[Layout<LayoutManager>?]> agentMdl =>
		`WithLayoutMutator<LayoutManager>.setLayout`;
}

shared final sealed annotation class WindowEventAnnotation(
	shared String listener,
	shared actual String pckg = "",
	shared actual Integer order = 4)
		satisfies
		OptionalAnnotation<WindowEventAnnotation,ComponentDecl>&
		ModelReaction<AbstractComponent,Anything,[Listener<EventListener>]>&
		PackageDependent&
		Order {
	shared actual Method<AbstractComponent,Anything,[Listener<EventListener>]> agentMdl =>
		`AbstractComponent.addListener`;
}

shared annotation TitleAnnotation title(
	String val,
	Integer order = 4) =>
		TitleAnnotation(val,order);

shared annotation SizeAnnotation size(
	Integer width, 
	Integer height, 
	Integer order = 1) =>
		SizeAnnotation(width, height, order);

shared annotation LocationAnnotation location(
	Integer x, 
	Integer y,
	Integer order = 3) =>
		LocationAnnotation(x, y, order);

shared annotation CenteredAnnotation centered(
	Integer order = 3) =>
		CenteredAnnotation(order);

shared annotation ParentAnnotation parent(
	String name,
	String pckg = "",
	Integer order = 2) =>
		ParentAnnotation(name, pckg, order);

shared annotation ExitOnCloseAnnotation exitOnClose(
	Integer order = 4) =>
		ExitOnCloseAnnotation(order);

shared annotation OnActionPerformedAnnotation onActionPerformed(
	String listener,
	String pckg = "",
	Integer order = 4) =>
		OnActionPerformedAnnotation(listener, pckg, order);

shared annotation WithLayoutAnnotation withLayout(
	String layout, 
	String pckg = "",
	Integer order = 4) =>
		WithLayoutAnnotation(layout, pckg, order);

shared annotation WindowEventAnnotation windowEvent(
	String listener, 
	String pckg = "",
	Integer order = 4) =>
		WindowEventAnnotation(listener, pckg, order);
