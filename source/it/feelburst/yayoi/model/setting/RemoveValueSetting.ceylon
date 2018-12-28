import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi.marker {
	RemoveValueAnnotation
}
shared interface RemoveValueSetting
	satisfies AbstractCollectRemoveValueSetting {
	shared actual RemoveValueAnnotation ann {
		assert (exists ann = annotations(`RemoveValueAnnotation`,decl));
		return ann;
	}
}
