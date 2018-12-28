import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
"Declaration from which the value originated"
shared sealed interface Declaration {
	shared formal ClassDeclaration|FunctionDeclaration|ValueDeclaration decl;
}
