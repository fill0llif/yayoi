import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.component {
	NameResolver,
	AnnotationReader
}
import it.feelburst.yayoi.marker {
	WindowAnnotation,
	ContainerAnnotation,
	ComponentAnnotation,
	ParentAnnotation,
	ListenerAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation,
	PackageDependent,
	SetLookAndFeelAnnotation,
	NamedAnnotation
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.stereotype {
	component
}

component
shared class NameResolverImpl() satisfies NameResolver {
	
	autowired
	late AnnotationReader annotationChecker;
	
	shared actual String|Exception resolve(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists ann = annotationChecker.component(decl)) then
			resolveComponent(decl,ann)
		else if (
			is FunctionDeclaration decl,
			exists ann = annotationChecker.action(decl)) then
			resolveAction(decl,ann)
		else
			Exception(
				"Name cannot be resolved. Declaration '``decl``' is neither a component nor an action.");
	
	String|Exception resolveComponent(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation ann) {
		switch (ann)
		case (is WindowAnnotation|LayoutAnnotation|ListenerAnnotation) {
			return "``resolveRoot(decl)``.``resolveUnbound(decl)``";
		}
		else {
			value cmp = resolveComponentChild(decl);
			if (is String cmp) {
				return "``resolveRoot(decl)``.``cmp``";
			}
			else {
				return cmp;
			}
		}
	}
	
	shared actual String resolveRoot(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		PackageDependent? pckgDpndnt) =>
		if (exists pd = pckgDpndnt,!pd.pckg.empty)
			then pd.pckg
			else decl.containingPackage.name;
	
	shared actual String resolveUnbound(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) {
		switch(decl)
		case(is ClassDeclaration|FunctionDeclaration) {
			return "``decl.name``()";
		}
		case(is ValueDeclaration) {
			return decl.name;
		}
	}
	
	String resolveAction(
		FunctionDeclaration decl, 
		DoLayoutAnnotation|SetLookAndFeelAnnotation ann) =>
		if (is SetLookAndFeelAnnotation ann) then
			"``resolveRoot(decl)``.``resolveUnbound(decl)``"
		else
			"``resolveRoot(decl,ann)``.``ann.container``.``resolveUnbound(decl)``";
	
	String|Exception resolveComponentChild(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists prntAnn = annotations(`ParentAnnotation`,decl)) then
			if (exists parent =
				decl.containingPackage
				.members<ClassDeclaration|FunctionDeclaration|ValueDeclaration>()
				.find((ClassDeclaration|FunctionDeclaration|ValueDeclaration cmp) =>
					let (prntName = prntAnn.name.substring(prntAnn.name.lastIndexOf(".") + 1))
					resolveUnbound(cmp) == prntName)) then
				let (prnt = resolveComponentChild(parent))
				if (is String prnt) then
					"``prnt``.``resolveUnbound(decl)``"
				else
					prnt
			else
				Exception(
					"Component name for '``decl``' cannot be resolved. Parent not found. " +
					"As a reminder, a component name is defined by its object's name or method/class's name " +
					"followed by round brackets (e.g. 'shared object main extends JFrame() {}' " +
					"-> 'main', 'shared JPanel panel() => JPanel();' -> 'panel()', etc.")
		else
			resolveUnbound(decl);
	
	shared actual String resolveNamed(
		FunctionDeclaration decl, 
		NamedAnnotation named) =>
		let (containingPckg =
			if (!named.pckg.empty) then
				named.pckg
			else
				decl.containingPackage.name)
		"``containingPckg``.``named.name``";
	
}
