import ceylon.language.meta.declaration {
	ValueDeclaration
}

import it.feelburst.yayoi.model.setting {
	LookAndFeelSetting
}
shared final class LookAndFeelSettingImpl(
	shared actual String name,
	shared actual ValueDeclaration decl)
	satisfies LookAndFeelSetting {}
