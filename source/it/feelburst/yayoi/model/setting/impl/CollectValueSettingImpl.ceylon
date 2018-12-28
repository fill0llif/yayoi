import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.model.setting {
	CollectValueSetting
}
shared final class CollectValueSettingImpl(
	shared actual String name,
	shared actual FunctionDeclaration decl)
	satisfies CollectValueSetting {}
