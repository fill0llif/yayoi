import ceylon.collection {
	HashMap
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	ComponentCollected,
	ComponentRemoved
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.component.awt {
	AbstractAwtComponent
}
import it.feelburst.yayoi.model.impl {
	AbstractNamedValue
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}

shared sealed abstract class AbstractAwtCollection<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtComponent<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	satisfies AbstractCollection
	given Type satisfies Object {
	
	value cmps = HashMap<String,AbstractComponent&Value<Object>>();
	
	shared actual void validate(Boolean internal) {
		super.validate();
		each((String name -> AbstractComponent&Value<Object> component) =>
			component.validate(false));
	}
	
	shared actual Boolean defines(Object name) =>
		cmps.defines(name);
	
	shared actual <AbstractComponent&Value<Object>>? get(Object name) =>
		cmps.get(name);
	
	shared actual Null add(
		AbstractComponent&Value<Object> component, 
		Boolean internal) {
		if (component == this) {
			value message =
				"SwingComponent '``component``' cannot be added to SwingCollection '``this``'. " +
				"They are the same object!";
			log.error(message);
			throw Exception(message);
		}
		else if (exists prvPrnt = component.parent,prvPrnt == this,
			defines(component.name)) {
			value message =
				"SwingComponent '``component``' cannot be added to SwingCollection '``this``'. " +
				"SwingComponent has already been added.";
			log.warn(message);
			throw Exception(message);
		}
		else if (exists prvPrnt = component.parent,prvPrnt != this) {
			value message =
				"SwingComponent '``component``' cannot be added to SwingCollection '``this``'. " +
				"SwingComponent already has the parent SwingCollection '``prvPrnt``', " +
				"remove the SwingComponent from the current parent SwingCollection.";
			log.error(message);
			throw Exception(message);
		}
		assert (!cmps.put(component.name, component) exists);
		if (internal) {
			value vl = val;
			invokeLater(() {
				try {
					collectValue(this.name,vl,component.name,component.val);
					publishEvent(ComponentCollected(this,component));
					log.debug("SwingComponent '``component.val``' added to SwingCollection '``vl``'.");
				}
				catch (Exception e) {
					log.error(
						"SwingComponent '``component.val``' has not been added " +
						"to SwingCollection '``vl``' due to the following " +
						"error: ``e.message``");
				}
			});
		}
		if (!component.parent exists) {
			component.parent = this;
		}
		log.info("SwingComponent '``component``' added to SwingCollection '``this``'.");
		return null;
	}
	
	shared actual <AbstractComponent&Value<Object>>? remove(String name) {
		if (exists component = cmps.remove(name)) {
			value vl = val;
			invokeLater(() {
				try {
					removeValue(this.name,vl,component.name,component.val);
					publishEvent(ComponentRemoved(this,component));
					log.debug("SwingComponent '``component.val``' removed from SwingCollection '``vl``'.");
				}
				catch (Exception e) {
					log.error(
						"SwingComponent '``component.val``' has not been removed " +
						"from SwingCollection '``vl``' due to the following " +
						"error: ``e.message``");
				}
			});
			component.parent = null;
			log.info("SwingComponent '``component``' removed from SwingCollection '``this``'.");
			return component;
		}
		else {
			log.warn(
				"SwingComponent with name '``name``' is not contained in SwingCollection '``this``' " +
				"or may not exist at all.");
			return null;
		}
	}
	
	shared actual Iterator<String->AbstractComponent&Value<Object>> iterator() =>
		cmps.iterator();
	
	shared actual String string =>
		(super of AbstractNamedValue<Type>).string;
	
	shared actual Integer hash =>
		(super of AbstractNamedValue<Type>).hash;
	
	shared actual Boolean equals(Object that) =>
		(super of AbstractNamedValue<Type>).equals(that);
	
}
