import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.model.setting {
	RemoveValueSetting
}
shared final class RemoveValueSettingImpl(
	shared actual String name,
	shared actual FunctionDeclaration decl)
	satisfies RemoveValueSetting {}
