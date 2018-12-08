import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	FunctionDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction,
	LookAndFeelAction
}
shared final sealed annotation class DoLayoutAnnotation(
	shared String container,
	shared actual String pckg = "")
	satisfies OptionalAnnotation<
		DoLayoutAnnotation,
		FunctionDeclaration>&
		PackageDependent&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface LayoutAction`;
}

shared final sealed annotation class SetLookAndFeelAnnotation()
	satisfies OptionalAnnotation<
		SetLookAndFeelAnnotation,
		FunctionDeclaration>&Marker {
	shared actual InterfaceDeclaration marked =>
		`interface LookAndFeelAction`;
}

shared annotation DoLayoutAnnotation doLayout(
	String container,
	String pckg = "") =>
	DoLayoutAnnotation(container, pckg);

shared annotation SetLookAndFeelAnnotation setLookAndFeel() =>
	SetLookAndFeelAnnotation();
