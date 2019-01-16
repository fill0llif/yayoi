import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.container {
	Layout
}
import it.feelburst.yayoi.model.impl {
	AbstractNamedValue
}

import java.awt {
	LayoutManager
}
"Swing implementation of a layout"
shared final class AwtLayout<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractNamedValue<Type>(name,declaration,vl) 
	satisfies Layout<Type>
	given Type satisfies LayoutManager {}
