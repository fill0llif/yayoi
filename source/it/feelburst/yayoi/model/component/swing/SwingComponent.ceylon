import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.component {
	Component
}

import javax.swing {
	JComponent
}

"Swing implementation of a component"
shared final class SwingComponent<Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractSwingComponent<Type>(name,declaration,vl,publishEvent)
	satisfies Component<Type>
	given Type satisfies JComponent {}
