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
import it.feelburst.yayoi.model.component.awt {

	AbstractAwtComponent
}

shared final class SwingComponent<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtComponent<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	satisfies Component<Type>
	given Type satisfies JComponent {}
