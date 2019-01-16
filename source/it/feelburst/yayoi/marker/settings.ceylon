import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	ValueDeclaration
}

import it.feelburst.yayoi.model.setting {
	LookAndFeelSetting
}

shared final sealed annotation class LookAndFeelAnnotation()
	satisfies
		OptionalAnnotation<
			LookAndFeelAnnotation,
			ValueDeclaration>&
		Marker {
	shared actual InterfaceDeclaration marked =>
		`interface LookAndFeelSetting`;
}

shared annotation LookAndFeelAnnotation lookAndFeel() =>
	LookAndFeelAnnotation();
