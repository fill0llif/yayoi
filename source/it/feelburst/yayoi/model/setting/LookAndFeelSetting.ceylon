import ceylon.language.meta.declaration {
	ValueDeclaration
}

import it.feelburst.yayoi.marker {
	Order,
	LookAndFeelAnnotation
}
import ceylon.language.meta {

	annotations
}
shared interface LookAndFeelSetting
	satisfies 
		Setting<String>&
		Order {
	shared formal actual ValueDeclaration decl;
	shared actual LookAndFeelAnnotation ann {
		assert (exists ann = annotations(`LookAndFeelAnnotation`,decl));
		return ann;
	}
	shared default actual String val =>
		decl.apply<String>().get();
	shared actual Integer order =>
		ann.order;
}
