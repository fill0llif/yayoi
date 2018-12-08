import ceylon.language.meta.declaration {
	FunctionDeclaration
}
shared sealed abstract class AbstractAction(
	shared default actual String name,
	shared default actual FunctionDeclaration decl)
	satisfies Action {}