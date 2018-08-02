import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi {
	ComponentDecl,
	ActionDecl
}
import it.feelburst.yayoi.behaviour.component {
	NameResolver,
	AnnotationChecker
}
import it.feelburst.yayoi.marker {
	WindowAnnotation,
	ContainerAnnotation,
	ComponentAnnotation,
	ParentAnnotation,
	ListenerAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation,
	PackageDependent
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
	late AnnotationChecker annotationChecker;
	
	shared actual String|Exception resolve(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) {
		if (exists cmpAnn = annotationChecker.component(decl)) {
			return resolveComponent(decl,cmpAnn);
		}
		else if (
			is ActionDecl decl,
			exists actAnn = annotationChecker.action(decl)) {
			return resolveAction(decl,actAnn);
		}
		else {
			return Exception("Declaration '``decl``' is neither a component nor an action.");
		}
	}
	
	String resolveComponent(
		ComponentDecl decl,
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation cmpAnn) {
		switch (cmpAnn)
		case (is WindowAnnotation|LayoutAnnotation|ListenerAnnotation) {
			return "``resolveRoot(decl)``.``resolveUnbound(decl)``";
		}
		else {
			return "``resolveRoot(decl)``.``resolveComponentChild(decl)``";
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
		case(is ClassDeclaration) {
			return "``decl.name``()";
		}
		case(is FunctionDeclaration) {
			return "``decl.name``()";
		}
		case(is ValueDeclaration) {
			return decl.name;
		}
	}
	
	String resolveAction(ActionDecl decl, DoLayoutAnnotation actAnn) =>
		"``resolveRoot(decl,actAnn)``.``actAnn.container``.``resolveUnbound(decl)``";
	
	String resolveComponentChild(ComponentDecl decl) {
		if (exists prntAnn = annotations(`ParentAnnotation`,decl)) {
			assert (is ComponentDecl parent =
				decl.containingPackage
				.members<ComponentDecl>()
				.find((ComponentDecl cmp) =>
					let (prntName = prntAnn.name.substring(prntAnn.name.lastIndexOf(".") + 1))
					resolveUnbound(cmp) == prntName));
			return "``resolveComponentChild(parent)``.``resolveUnbound(decl)``";
		} else {
			return resolveUnbound(decl);
		}
	}
	
}
