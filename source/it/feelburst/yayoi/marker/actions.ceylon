import ceylon.language.meta.declaration {
	InterfaceDeclaration,
	FunctionDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	LayoutAction
}
import it.feelburst.yayoi.model {
	Named
}
shared final sealed annotation class DoLayoutAnnotation(
	shared actual String name,
	shared actual String pckg = "")
	satisfies OptionalAnnotation<
		DoLayoutAnnotation,
		FunctionDeclaration>&
		Named&
		PackageDependent&
		Marker&
		Order {
	shared actual InterfaceDeclaration marked =>
		`interface LayoutAction`;
	shared actual Integer order => 1;
}

shared annotation DoLayoutAnnotation doLayout(
	String container,
	String pckg = "") =>
	DoLayoutAnnotation(container, pckg);
