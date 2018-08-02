import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.model {
	Named
}
import it.feelburst.yayoi.model.window {

	Window
}
import it.feelburst.yayoi.model.container {

	Container,
	Layout
}
import it.feelburst.yayoi.model.component {

	Component
}
import it.feelburst.yayoi.model.listener {

	Listener
}
"An action to be executed on one or more components."
see(
	`interface Component`,
	`interface Container`,
	`interface Window`,
	`interface Listener`,
	`interface Layout`)
shared interface Action satisfies Named {
	"Action declaration"
	shared formal FunctionDeclaration decl;
	"Action annotation"
	shared formal Annotation ann;
	"Action execution"
	shared formal void execute();
}