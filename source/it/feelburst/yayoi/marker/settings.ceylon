import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	FunctionDeclaration,
	ValueDeclaration
}

import it.feelburst.yayoi.model.setting {
	CollectValueSetting,
	RemoveValueSetting,
	LookAndFeelSetting
}

shared final sealed annotation class LookAndFeelAnnotation()
	satisfies
		OptionalAnnotation<
			LookAndFeelAnnotation,
			ValueDeclaration>&
		Marker&
		Order {
	shared actual InterfaceDeclaration marked =>
		`interface LookAndFeelSetting`;
	shared actual Integer order => 1;
}

shared final sealed annotation class CollectValueAnnotation(
	shared actual Integer order)
	satisfies
		OptionalAnnotation<
			CollectValueAnnotation,
			FunctionDeclaration>&
		Marker&
		Order {
	shared actual InterfaceDeclaration marked =>
		`interface CollectValueSetting`;
}

shared final sealed annotation class RemoveValueAnnotation(
	shared actual Integer order)
	satisfies
		OptionalAnnotation<
			RemoveValueAnnotation,
			FunctionDeclaration>&
		Marker&
		Order {
	shared actual InterfaceDeclaration marked =>
		`interface RemoveValueSetting`;
}

shared annotation CollectValueAnnotation collectValue(
	Integer order = 0) =>
	CollectValueAnnotation(order);

shared annotation RemoveValueAnnotation removeValue(
	Integer order = 0) =>
	RemoveValueAnnotation(order);

shared annotation LookAndFeelAnnotation lookAndFeel() =>
	LookAndFeelAnnotation();
