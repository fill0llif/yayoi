import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.collection {
	Collection
}

shared final class AwtCollection<out Type>(
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
	given Type satisfies Object {}
