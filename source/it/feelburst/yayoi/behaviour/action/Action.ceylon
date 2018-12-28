import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.model {
	Named,
	Declaration
}
import it.feelburst.yayoi.model.component {
	Component
}
import it.feelburst.yayoi.model.container {
	Container,
	Layout
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.window {
	Window
}
import it.feelburst.yayoi.model.collection {
	Collection
}
"An action to be executed on one or more components."
see(
	`interface Component`,
	`interface Container`,
	`interface Collection`,
	`interface Window`,
	`interface Listener`,
	`interface Layout`)
shared sealed interface Action
	satisfies Named&Declaration {
	"Action declaration"
	shared formal actual FunctionDeclaration decl;
	"Action annotation"
	shared formal Annotation ann;
	"Action execution"
	shared formal void execute();
	
	shared actual String string =>
		name;
	
}