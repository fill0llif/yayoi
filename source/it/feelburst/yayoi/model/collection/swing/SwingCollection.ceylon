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

import java.awt {
	Container
}
shared final class SwingCollection<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void addValue(Object cltr, Object cltd),
	void removeValue(Object cltr, Object cltd),
	void publishEvent(Object event))
	extends AbstractSwingCollection<Type>(
		name,
		declaration,
		vl,
		addValue,
		removeValue,
		publishEvent)
	satisfies Collection<Type>
	given Type satisfies Container {}
