import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
shared interface Declaration {
	"Declaration from which the value originated"
	shared formal ClassDeclaration|FunctionDeclaration|ValueDeclaration decl;
}
