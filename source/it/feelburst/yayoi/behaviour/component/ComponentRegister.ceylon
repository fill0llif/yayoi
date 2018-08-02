import ceylon.language.meta.declaration {
	Package,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}
"Component and action register"
shared interface ComponentRegister {
	shared formal AnnotationChecker annotationChecker;
	shared formal NameResolver nameResolver;
	"Register a component or an action"
	shared formal void register(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl);
	"Register components and actions contained in the given packages"
	shared default void registerByPackages(Package+ packages) =>
		packages
		.each((Package pckge) =>
			pckge
			.members<ClassDeclaration|FunctionDeclaration|ValueDeclaration>()
			.filter((ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
				if (annotationChecker.component(decl) exists) then
					true
				else if (is FunctionDeclaration decl) then
					annotationChecker.action(decl) exists
				else false)
			.sort((ClassDeclaration|FunctionDeclaration|ValueDeclaration x,
				ClassDeclaration|FunctionDeclaration|ValueDeclaration y) {
					assert (is String xName = nameResolver.resolve(x));
					assert (is String yName = nameResolver.resolve(y));
					return xName <=> yName;
			})
			.each((ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
				register(decl)));
}
