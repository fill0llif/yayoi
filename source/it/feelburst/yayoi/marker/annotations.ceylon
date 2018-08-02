import ceylon.language.meta.declaration {
	Package,
	ClassDeclaration
}
import ceylon.language.meta.model {
	Method
}

shared interface ModelReaction<in Container=Nothing,out Type=Anything,in Arguments=Nothing>
	given Arguments satisfies Anything[] {
	shared formal Method<Container,Type,Arguments> agentMdl;
}

shared interface Order {
	shared default Integer highestPrecedence => runtime.minIntegerValue;
	shared default Integer lowestPrecedence => runtime.maxIntegerValue;
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

shared final sealed annotation class YayoiAnnotation(
	shared {Package+} basePackages,
	shared String frameworkImpl = "swing")
		satisfies OptionalAnnotation<YayoiAnnotation,ClassDeclaration> {}

shared annotation YayoiAnnotation yayoi(
	{Package+} basePackages,
	String frameworkImpl = "swing") =>
		YayoiAnnotation(basePackages, frameworkImpl);
