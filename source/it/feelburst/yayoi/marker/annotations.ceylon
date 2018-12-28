import ceylon.language.meta.declaration {
	Package,
	ClassDeclaration,
	InterfaceDeclaration,
	ValueDeclaration,
	FunctionDeclaration
}

import it.feelburst.yayoi.model {
	Named
}

shared interface Order {
	shared Integer highestPrecedence => runtime.minIntegerValue;
	shared Integer lowestPrecedence => runtime.maxIntegerValue;
	shared formal Integer order;
}

shared object highestPrecedenceOrder satisfies Order {
	shared actual Integer order => highestPrecedence;
}

shared object lowestPrecedenceOrder satisfies Order {
	shared actual Integer order => lowestPrecedence;
}

shared interface PackageDependent {
	shared formal String pckg;
}

shared interface Marker {
	shared formal InterfaceDeclaration marked;
}

shared final sealed annotation class YayoiAnnotation(
	shared {Package+} basePackages,
	shared ValueDeclaration frameworkImpl)
	satisfies
		OptionalAnnotation<YayoiAnnotation,ClassDeclaration> {}

shared final sealed annotation class NamedAnnotation(
	shared actual String name,
	shared actual String pckg)
	satisfies
		OptionalAnnotation<NamedAnnotation,ValueDeclaration>&
		Named&
		PackageDependent {}

shared final sealed annotation class OrderingAnnotation(
	shared {NamedAnnotation*} named)
	satisfies
		OptionalAnnotation<
			OrderingAnnotation,
			ClassDeclaration|FunctionDeclaration|ValueDeclaration> {}

shared annotation YayoiAnnotation yayoi(
	{Package+} basePackages,
	ValueDeclaration frameworkImpl) =>
	YayoiAnnotation(basePackages, frameworkImpl);

shared annotation NamedAnnotation named(
	String name,
	String pckg = "") =>
	NamedAnnotation(name,pckg);

shared annotation OrderingAnnotation ordering(
	{NamedAnnotation*} named) =>
	OrderingAnnotation(named);
