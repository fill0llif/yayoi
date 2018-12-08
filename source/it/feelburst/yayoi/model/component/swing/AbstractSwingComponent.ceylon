import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	Centered,
	LocationSet,
	SizeSet,
	Displayed,
	Hidden
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model {
	Reactor,
	Value
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}
import it.feelburst.yayoi.model.impl {
	ReactorImpl,
	AbstractNamedValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.awt {
	JContainer=Container
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
shared sealed abstract class AbstractSwingComponent<Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractNamedValue<Type>(name,declaration,vl)
	satisfies AbstractComponent&Reactor
	given Type satisfies JContainer {
	
	value awtContainer = AwtContainer(name,vl,publishEvent);
	value reactor = ReactorImpl();
	
	shared actual variable AbstractContainer? parent = null;
	
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
	
	shared actual void display() {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value vl = val;
		invokeLater(() {
			awtContainer.display();
			publishEvent(Displayed(this));
			log.debug("GUIEvent: SwingComponent '``this``' is now visible.");
		});
	}
	
	shared actual void hide() {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value vl = val;
		invokeLater(() {
			awtContainer.hide();
			publishEvent(Hidden(this));
			log.debug("GUIEvent: SwingComponent '``this``' is now hidden.");
		});
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value vl = val;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.debug("GUIEvent: Location set at (``x``,``y``) for SwingComponent '``this``'.");
		});
	}
	
	shared actual void setSize(Integer width, Integer height) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value vl = val;
		invokeLater(() {
			awtContainer.setSize(width, height);
			publishEvent(SizeSet(this,width,height));
			log.debug("GUIEvent: Size (``width``,``height``) set for SwingComponent '``this``'.");
		});
	}
	
	shared default actual void center() {
		value parentWidth = val.parent.width;
		value parentHeight = val.parent.height;
		value x = (parentWidth - width) / 2;
		value y = (parentHeight - height) / 2;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.debug("GUIEvent: Location set at (``x``,``y``) for SwingComponent '``this``'.");
			publishEvent(Centered(this));
			log.debug("GUIEvent: SwingComponent '``this``' centered.");
		});
	}
	
	shared actual Listener<Anything>[] listeners =>
		awtContainer.listeners;
	
	shared actual Listener<Anything>? listener(String name) =>
		awtContainer.listener(name);
	
	shared actual void addListener(Listener<Anything> listener) {
		log.info("AwtListener '``listener``' added to SwingComponent '``this``'.");
		awtContainer.addListener(listener);
	}
	
	shared actual Listener<Anything>? removeListener(String name) {
		if (exists listener = awtContainer.removeListener(name)) {
			log.info("AwtListener '``listener``' removed from SwingComponent '``this``'.");
			return listener;
		}
		else {
			return null;
		}
	}
	
	shared actual Reaction<Type>[] reactions<Type=Object>()
		given Type satisfies Object =>
		reactor.reactions<Type>();
	
	shared actual void addReaction(Reaction<> reaction) =>
		reactor.addReaction(reaction);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		reactor.setReactions(reactions);
	
}