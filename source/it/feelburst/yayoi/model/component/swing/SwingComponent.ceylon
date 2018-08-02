import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	VisibleSet,
	LocationSet,
	SizeSet,
	Centered,
	IndependentDoneExecuting
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	SizeReaction
}
import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}
import it.feelburst.yayoi.model.impl {
	ReactorImpl
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.awt {
	JContainer=Container
}
import java.util {
	EventListener
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}

import org.springframework.context {
	ApplicationEvent
}

"Swing implementation of a component"
shared class SwingComponent<out Type>(
	shared actual String name,
	Source<Type> source,
	void publishEvent(ApplicationEvent event))
		satisfies Component<Type>
		given Type satisfies JContainer {
	
	value awtContainer = AwtContainer(name,source,publishEvent);
	value reactor = ReactorImpl();
	
	shared actual AbstractContainer? parent =>
		awtContainer.parent;
	
	shared actual void setParent(AbstractContainer? parent) =>
		awtContainer.setParent(parent);
	
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
