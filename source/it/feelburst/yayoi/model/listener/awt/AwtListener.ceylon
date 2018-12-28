import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.impl {
	AbstractNamedValue
}
import it.feelburst.yayoi.model.listener {
	Listener
}

import java.util {
	EventListener
}
"Awt implementation of a listener"
shared final class AwtListener<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractNamedValue<Type>(name,declaration,vl)
	satisfies Listener<Type>
	given Type satisfies EventListener {}
