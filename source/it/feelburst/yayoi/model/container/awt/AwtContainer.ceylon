import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.container {
	Container
}

import java.awt {
	JContainer=Container
}
shared final class AwtContainer<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtContainer<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	satisfies Container<Type>
	given Type satisfies JContainer {}
