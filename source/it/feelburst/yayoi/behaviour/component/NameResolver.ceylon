import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.marker {
	PackageDependent
}
import it.feelburst.yayoi.model {
	Named
}
"Component, action, setting name resolver"
shared sealed interface NameResolver {
	"Resolve a component or an action name"
	shared formal String|Exception resolve(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Resolve a component or an action name without regard to the root (e.g. package)"
	shared formal String resolveUnbound(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Resolve a component or an action root (e.g. package)"
	shared formal String resolveRoot(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		PackageDependent? pckgDpndnt = null);
	"Resolve a named component"
	shared formal String resolveNamed(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		Named&PackageDependent named);
}