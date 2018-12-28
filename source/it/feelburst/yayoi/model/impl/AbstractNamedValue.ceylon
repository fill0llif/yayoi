import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.model {
	Declaration,
	Named,
	Value
}
shared sealed abstract class AbstractNamedValue<out Type>(
	shared actual String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl)
	satisfies Named&Declaration&Value<Type>
	given Type satisfies Object {
	
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl {
		if (exists declaration) {
			return declaration;
		}
		else {
			value message =
				"Component '``this``' has no source because has been constructed programmatically.";
			log.warn(message);
			throw Exception(message);
		}
	}
	
	shared actual Type val =>
		vl.val;
	
	shared default actual String string =>
		name;
	
	shared default actual Integer hash =>
		name.hash;
	
	shared default actual Boolean equals(Object that) {
		if (is AbstractNamedValue<Object> that) {
			return name==that.name;
		}
		else {
			return false;
		}
	}
	
}
