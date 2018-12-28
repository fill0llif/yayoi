import ceylon.language.meta.declaration {
	Package,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
"Component, action, setting register"
shared sealed interface ComponentRegistry {
	shared formal AnnotationReader annotationChecker;
	shared formal NameResolver nameResolver;
	"Register a component or an action"
	shared formal void register(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Register components and actions contained in the given packages"
	shared void registerByPackages(Package+ packages) =>
		packages
		.each((Package pckge) =>
			pckge
			.members<ClassDeclaration|FunctionDeclaration|ValueDeclaration>()
			.filter((ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
				annotationChecker.component(decl) exists ||
				annotationChecker.action(decl) exists ||
				annotationChecker.setting(decl) exists)
			.each((ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
				register(decl)));
	"Get internal component or action function with autowired component parameters"
	shared formal <Type|Exception>() autowired<Type=Anything>(
		String name,
		FunctionDeclaration decl);
}
