import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi.marker {
	CollectValueAnnotation
}
shared interface CollectValueSetting
	satisfies AbstractCollectRemoveValueSetting {
	shared actual CollectValueAnnotation ann {
		assert (exists ann = annotations(`CollectValueAnnotation`,decl));
		return ann;
	}
}
