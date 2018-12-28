import ceylon.collection {
	HashMap
}
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
	Hidden,
	ListenerCollected,
	ListenerRemoved
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model {
	Reactor,
	Value,
	ComponentMutableMap
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.impl {
	ReactorImpl,
	AbstractNamedValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.awt {
	Container
}
import java.lang {
	volatile
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
shared sealed abstract class AbstractSwingComponent<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void addValue(Object cltr, Object cltd),
	void removeValue(Object cltr, Object cltd),
	void publishEvent(Object event))
	extends AbstractNamedValue<Type>(name,declaration,vl)
	satisfies AbstractComponent&Reactor
	given Type satisfies Container {
	
	value awtContainer = AwtContainer(name,vl,publishEvent);
	value reactor = ReactorImpl();
	value lstnrs = HashMap<String,Listener<Object>>();
	
	volatile variable value internalValid = true;
	
	shared actual variable AbstractCollection? parent = null;
	
	shared actual Boolean valid =>
		internalValid;
	
	shared default actual void invalidate(Boolean internal) {
		if (internal) {
			value vl = val;
			invokeLater(() {
				if (awtContainer.valid) {
					awtContainer.invalidate();
					log.debug("SwingComponent '``vl``' and its ancestors invalidated.");
				}
			});
		}
		if (exists parent = this.parent) {
			parent.invalidate(false);
		}
		internalValid = false;
	}
	
	shared default actual void validate(Boolean internal) {
		if (internal) {
			value vl = val;
			invokeLater(() {
				if (!awtContainer.valid) {
					awtContainer.validate();
					log.debug("SwingComponent '``vl``' and its components validated.");
				}
			});
		}
		internalValid = true;
	}
	
	shared actual object listeners
		satisfies ComponentMutableMap<String,Listener<Object>> {
			
			shared actual Boolean defines(Object name) =>
				lstnrs.defines(name);
			
			shared actual Listener<Object>? get(Object name) =>
				lstnrs.get(name);
			
			shared actual Listener<Object>? add(
				Listener<Object> listener, 
				Boolean internal) {
				value prvsLstnr = lstnrs.put(listener.name, listener);
				if (internal) {
					invokeLater(() {
						try {
							addValue(vl.val,listener.val);
							publishEvent(ListenerCollected(outer,listener));
							log.debug(
								"AwtListener '``listener.val``' added to SwingComponent '``vl.val``'.");
						}
						catch (Exception e) {
							log.error(
								"AwtListener '``listener.val``' has not been added " +
								"to SwingComponent '``vl.val``' due to the following " +
								"error: ``e.message``");
						}
					});
				}
				log.info(
					"AwtListener '``listener``' added to SwingComponent '``outer``'.");
				return prvsLstnr;
			}
			
			shared actual Listener<Object>? remove(String name) {
				if (exists listener = lstnrs.remove(name)) {
					invokeLater(() {
						try {
							removeValue(vl.val,listener.val);
							publishEvent(ListenerRemoved(outer,listener));
							log.debug(
								"AwtListener '``listener.val``' removed from SwingComponent '``vl.val``'.");
						}
						catch (Exception e) {
							log.error(
								"AwtListener '``listener.val``' has not been removed " +
								"from SwingComponent '``vl.val``' due to the following " +
								"error: ``e.message``");
						}
					});
					log.info(
						"AwtListener '``listener``' removed from SwingComponent '``outer``'.");
					return listener;
				}
				else {
					log.warn(
						"AwtListener '``name``' is not contained in SwingComponent '``outer``' " +
						"or may not exist at all.");
					return null;
				}
			}
			
			shared actual Iterator<String->Listener<Object>> iterator() =>
				lstnrs.iterator();
			
			shared actual Integer hash =>
				lstnrs.hash;
			
			shared actual Boolean equals(Object that) =>
				lstnrs.equals(that);
		
	}
	
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
			publishEvent(Centered(this));
			log.debug("GUIEvent: SwingComponent '``this``' centered.");
		});
	}
	
	shared actual Reaction<Type>[] reactions<Type=Object>()
		given Type satisfies Object =>
		reactor.reactions<Type>();
	
	shared actual void addReaction(Reaction<> reaction) =>
		reactor.addReaction(reaction);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		reactor.setReactions(reactions);
	
}
