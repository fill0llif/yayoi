import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.collection.awt {
	AbstractAwtCollection
}
import it.feelburst.yayoi.model.container {
	Layout,
	Container
}
import it.feelburst.yayoi.model.impl {
	LateValue
}

import java.awt {
	JContainer=Container,
	LayoutManager
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
shared abstract class AbstractAwtContainer<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtCollection<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	satisfies Container<Type>
	given Type satisfies JContainer {
	
	late variable Layout<LayoutManager>? lyt =
		AwtLayout<LayoutManager>(
			"``name``.awtLayout",
			null,
			LateValue<LayoutManager>(() =>
				vl.val.layout),
			publishEvent);
	
	shared actual Layout<Object>? layout =>
		lyt;
	
	assign layout {
		if (is Layout<LayoutManager> layt = layout) {
			value val = vl.val;
			invokeLater(() {
				val.layout = layt.val;
			});
			lyt = layt;
			log.debug(
				"AwtSwingLayout '``layt.val``' added to AwtSwingContainer '``vl.val``'.");
			log.info(
				"AwtSwingLayout '``layt``' added to AwtSwingContainer '``this``'.");
		}
		else if (is Layout<Object> layt = layout) {
			log.warn(
				"AwtSwingLayout '``layt``' cannot be added to AwtSwingContainer '``this``'. " +
				"AwtSwingLayout generic type must be a '`` `interface LayoutManager`.name ``'.");
		}
		else {
			value val = vl.val;
			invokeLater(() {
				val.layout = null;
			});
			lyt = null;
			log.debug("Null AwtSwingLayout added to AwtSwingContainer '``vl.val``'.");
			log.info("Null AwtSwingLayout added to AwtSwingContainer '``this``'.");
		}
	}
	
}
