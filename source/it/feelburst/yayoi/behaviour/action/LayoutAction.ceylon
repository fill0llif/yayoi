import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi.marker {
	DoLayoutAnnotation
}
"Layout settings action"
shared interface LayoutAction satisfies Action {
	shared default actual DoLayoutAnnotation ann {
		assert (exists ann = annotations(`DoLayoutAnnotation`,decl));
		return ann;
	}
}