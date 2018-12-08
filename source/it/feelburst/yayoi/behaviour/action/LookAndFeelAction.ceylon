import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi.marker {
	SetLookAndFeelAnnotation
}
"Look and Feel settings action"
shared interface LookAndFeelAction satisfies Action {
	shared default actual SetLookAndFeelAnnotation ann {
		assert (exists ann = annotations(`SetLookAndFeelAnnotation`,decl));
		return ann;
	}
}