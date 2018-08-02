import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
"A source is an object with originates from a declaration"
shared interface Source<out Type=Object>
	given Type satisfies Object {
	"Declaration from which the source originated"
	shared formal ClassDeclaration|FunctionDeclaration|ValueDeclaration decl;
	"Object from which the source originated"
	shared formal Type val;
}
