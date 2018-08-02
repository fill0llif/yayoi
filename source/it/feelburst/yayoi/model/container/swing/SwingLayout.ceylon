import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.container {
	Layout
}

import java.awt {
	LayoutManager
}

import org.springframework.context {
	ApplicationEvent
}
"Swing implementation of a layout"
shared class SwingLayout<out Type>(
	shared actual String name,
	Source<Type> source,
	void publishEvent(ApplicationEvent event))
	satisfies Layout<Type>
	given Type satisfies LayoutManager {
	
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl =>
		source.decl;
	
	shared actual Type val =>
		source.val;
	
	shared actual String string =>
		name;
}