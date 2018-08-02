import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Source
}
"A source whose original object is lazily load"
shared class LateSource<Type=Object>(
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
	Type src())
	satisfies Source<Type>
	given Type satisfies Object {
	shared actual late Type val = src();
}