import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	Container,
	AbstractContainer,
	Layout
}
import it.feelburst.yayoi.model.impl {
	ReactorImpl
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}

import java.awt {
	JContainer=Container,
	LayoutManager
}
import java.util {
	EventListener
}

import javax.swing {
	JFrame,
	SwingUtilities {
		invokeLater
	}
}

import org.springframework.context {
	ApplicationEvent
}
import it.feelburst.yayoi.behaviour.listener.model {

	SizeSet,
	VisibleSet,
	Centered,
	LocationSet,
	IndependentDoneExecuting
}
import it.feelburst.yayoi.behaviour.reaction.impl {

	SizeReaction
}
"Swing implementation of a container"
shared class SwingContainer<out Type,LayoutType>(
	shared actual String name,
	Source<Type> source,
	void publishEvent(ApplicationEvent event))
		satisfies Container<Type,LayoutType>
		given Type satisfies JContainer
		given LayoutType satisfies LayoutManager  {
	
	value awtContainer = AwtContainer(name,source,publishEvent);
	value swingWithLayout = SwingMutableWithLayout<Type,LayoutType>(source);
	value reactor = ReactorImpl();
	
	shared actual Layout<LayoutType>? layout =>
		swingWithLayout.layout;
	
	shared actual void setLayout(Layout<LayoutType>? layout) =>
		swingWithLayout.setLayout(layout);
	
	shared actual AbstractContainer? parent =>
		awtContainer.parent;
	
	shared actual void setParent(AbstractContainer? parent) {
		if (is Window<JFrame> prnt = parent) {
			prnt.val.contentPane = val;
		}
		awtContainer.setParent(parent);
	}
	
	shared actual AbstractContainer? root =>
		awtContainer.root;
	
	shared actual Integer x =>
		awtContainer.x;
	
	shared actual Integer y =>
		awtContainer.y;
	
	shared actual Integer width =>
		awtContainer.width;
	
	shared actual Integer height =>
		awtContainer.height;
	
	shared actual Boolean visible =>
		awtContainer.visible;
	
	shared actual void setVisible(Boolean visible) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setVisible(visible);
			publishEvent(VisibleSet(this, visible));
			log.debug(
				"Component '``this``' is now " +
				"``visible then "" else "not "``visible.");
		});
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.info("Location set at (``x``,``y``) for Component '``this``'.");
		});
	}
	
	shared actual void setSize(Integer width, Integer height) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setSize(width, height);
			publishEvent(SizeSet(this,width,height));
			publishEvent(IndependentDoneExecuting(
				this,
				(Reaction<Object> rctn) =>
					rctn is SizeReaction));
			log.info("Size (``width``,``height``) set for Component '``this``'.");
		});
	}
	
	shared actual void center() {
		value parentWidth = val.parent.width;
		value parentHeight = val.parent.height;
		value x = (parentWidth - width) / 2;
		value y = (parentHeight - height) / 2;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.info("Location set at (``x``,``y``) for Component '``this``'.");
			publishEvent(Centered(this));
			log.info("Component '``this``' centered.");
		});
	}
	
	shared actual AbstractComponent? component(String name) =>
		awtContainer.component(name);
	
	shared actual AbstractComponent[] components =>
		awtContainer.components;
	
	shared actual void addComponent(AbstractComponent component) =>
		awtContainer.addComponent(component);
	
	shared actual void removeComponent(String name) =>
		awtContainer.removeComponent(name);
	
	shared actual Listener<EventListener>[] listeners =>
		awtContainer.listeners;
	
	shared actual Listener<EventListener>? listener(String name) =>
		awtContainer.listener(name);
	
	shared actual void addListener(Listener<EventListener> listener) =>
		awtContainer.addListener(listener);
	
	shared actual void removeListener(String name) =>
		awtContainer.removeListener(name);
	
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl =>
		source.decl;
	
	shared actual Type val =>
		source.val;
	
	shared actual Reaction<>[] reactions =>
		reactor.reactions;
	
	shared actual void addReaction(Reaction<> reaction) =>
		reactor.addReaction(reaction);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		reactor.setReactions(reactions);
	
	shared actual String string =>
		name;
	
}