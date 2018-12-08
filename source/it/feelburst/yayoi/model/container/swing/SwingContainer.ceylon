import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}

import java.awt {
	JContainer=Container
}
"Swing implementation of a container"
shared final class SwingContainer<Type,LayoutType>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractSwingContainer<Type>(name,declaration,vl,publishEvent)
	satisfies Container<Type,LayoutType>
	given Type satisfies JContainer
	given LayoutType satisfies Object {
	
	value swingWithLayout =
		SwingMutableWithLayout<Type,LayoutType>(name,vl,publishEvent);
	
	shared actual Layout<LayoutType>? layout =>
		swingWithLayout.layout;
	
	shared actual void setLayout(Layout<LayoutType>? layout) {
		swingWithLayout.setLayout(layout);
		if (exists layout) {
			log.info("SwingLayout '``layout``' added to SwingContainer '``this``'.");
		}
		else {
			log.info("Null layout added to SwingContainer '``this``'.");
		}
	}
	
}