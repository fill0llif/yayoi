import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	ValueDeclaration
}

import it.feelburst.yayoi.marker {
	LookAndFeelAnnotation
}
shared interface LookAndFeelSetting
	satisfies 
		Setting<String> {
	shared formal actual ValueDeclaration decl;
	shared actual LookAndFeelAnnotation ann {
		assert (exists ann = annotations(`LookAndFeelAnnotation`,decl));
		return ann;
	}
	shared default actual String val =>
		decl.apply<String>().get();
}
