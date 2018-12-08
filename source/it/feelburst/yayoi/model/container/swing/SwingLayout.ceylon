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
"Swing implementation of a layout"
shared final class SwingLayout<Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractNamedValue<Type>(name,declaration,vl) 
	satisfies Layout<Type>
	given Type satisfies Object {}
