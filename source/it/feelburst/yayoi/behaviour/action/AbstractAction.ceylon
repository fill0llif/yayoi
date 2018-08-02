import ceylon.language.meta.declaration {
	FunctionDeclaration
}
shared abstract class AbstractAction(
	shared default actual String name,
	shared default actual FunctionDeclaration decl)
	satisfies Action {}