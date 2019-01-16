import it.feelburst.yayoi.model {

	Value
}
import ceylon.language.meta.declaration {

	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
import it.feelburst.yayoi.model.collection {

	Collection,
	AbstractCollection
}
import java.awt {

	SystemTray {
		supported
	}
}
shared final class AwtSystemTrayCollection<out Type>(
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
	satisfies Collection<Type>
	given Type satisfies Object {
	
	if (!supported) {
		value message = "AwtSystemTray '``name``' is not supported.";
		log.error(message);
		throw Exception(message);
	}
	
	shared actual AbstractCollection? root =>
		this;
	
}
