import ceylon.language.meta.declaration {
	Package,
	ClassDeclaration,
	InterfaceDeclaration,
	ValueDeclaration
}
import ceylon.language.meta.model {
	Method
}

shared interface ModelReaction<in Container=Nothing,out Type=Anything,in Arguments=Nothing>
	given Arguments satisfies Anything[] {
	shared formal Method<Container,Type,Arguments> agentMdl;
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
	satisfies OptionalAnnotation<YayoiAnnotation,ClassDeclaration> {}

shared final sealed annotation class NamedAnnotation(
	shared String name,
	shared actual String pckg)
	satisfies
		OptionalAnnotation<NamedAnnotation,ValueDeclaration>&
		PackageDependent {}

shared annotation YayoiAnnotation yayoi(
	{Package+} basePackages,
	ValueDeclaration frameworkImpl) =>
	YayoiAnnotation(basePackages, frameworkImpl);

shared annotation NamedAnnotation named(
	String name,
	String pckg = "") =>
	NamedAnnotation(name,pckg);
