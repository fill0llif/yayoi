import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	ComponentAdded
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.component.swing {
	AbstractSwingComponent
}
import it.feelburst.yayoi.model.container {
	AbstractContainer,
	MutableContainer
}

import java.awt {
	JContainer=Container
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
shared sealed abstract class AbstractSwingContainer<Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractSwingComponent<Type>(name,declaration,vl,publishEvent)
	satisfies AbstractContainer
	given Type satisfies JContainer {
	
	value awtMutableContainer = MutableContainer();
	
	shared actual AbstractComponent? component(String name) =>
		awtMutableContainer.component(name);
	
	shared actual AbstractComponent[] components =>
		awtMutableContainer.components;
	
	shared actual void addComponent(AbstractComponent component) {
		if (exists prvPrnt = component.parent,prvPrnt == this) {
			return;
		}
		else if (exists prvPrnt = component.parent,prvPrnt != this) {
			log.error(
				"SwingComponent '``component``' cannot be added to SwingContainer '``this``'. " +
				"SwingComponent already has the parent SwingContainer '``prvPrnt``', " +
				"remove the SwingComponent from the current parent SwingContainer.");
			return;
		}
		awtMutableContainer.addComponent(component);
		publishEvent(ComponentAdded(component,this,() {
			assert (is Value<JContainer> component);
			value vl = val;
			invokeLater(() {
				vl.add(component.val);
				vl.validate();
				vl.repaint();
				log.info("SwingComponent '``component``' added to SwingContainer '``this``'.");
				log.debug("SwingComponent '``component.val``' added to SwingContainer '``vl``'.");
			});
		}));
		component.parent = this;
	}
	
	shared actual AbstractComponent? removeComponent(String name) {
		if (is Value<JContainer> component = awtMutableContainer.removeComponent(name)) {
			value vl = val;
			invokeLater(() {
				vl.remove(component.val);
				vl.validate();
				vl.repaint();
				log.info("SwingComponent '``component``' removed from SwingContainer '``this``'.");
				log.debug("SwingComponent '``component.val``' removed from SwingContainer '``vl``'.");
			});
			component.parent = null;
			return component;
		}
		else {
			log.warn(
				"SwingComponent with name '``name``' is not contained in SwingContainer '``this``' " +
				"or may not exist at all.");
			return null;
		}
	}
	
}