import ceylon.language.meta {
	annotations,
	modules
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	Package,
	Module
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
	CollectionAnnotation,
	CollectValueAnnotation,
	RemoveValueAnnotation,
	LookAndFeelAnnotation
}
import it.feelburst.yayoi.model {
	Named
}

import org.springframework.beans.factory.annotation {
	autowired
}
import org.springframework.stereotype {
	component
}
import ceylon.collection {

	HashMap
}

component
shared class NameResolverImpl() satisfies NameResolver {
	
	autowired
	late AnnotationReader annotationChecker;
	
	value pckgCache = HashMap<String,Package>();
	
	shared actual String|Exception resolve(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists ann = annotationChecker.component(decl)) then
			resolveComponent(decl,ann)
		else if (
			is FunctionDeclaration decl,
			exists ann = annotationChecker.action(decl)) then
			resolveAction(decl,ann)
		else if (exists ann = annotationChecker.setting(decl)) then
			resolveSetting(decl,ann)
		else
			Exception(
				"Name cannot be resolved. Declaration '``decl``' is neither a component nor an action.");
	
	String|Exception resolveComponent(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ComponentAnnotation|ContainerAnnotation|CollectionAnnotation|WindowAnnotation|
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
		if (exists pd = pckgDpndnt,!pd.pckg.empty) then
			pd.pckg
		else
			decl.containingPackage.name;
	
	shared actual String resolveNamed(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl, 
		Named&PackageDependent named) =>
		"``resolveRoot(decl,named)``.``named.name``";
	
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
		DoLayoutAnnotation ann) =>
		"``resolveRoot(decl,ann)``.``ann.name``.``resolveUnbound(decl)``";
	
	String resolveSetting(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl, 
		LookAndFeelAnnotation|CollectValueAnnotation|RemoveValueAnnotation ann) =>
		"``resolveUnbound(decl)``";
	
	Package? findParentPackage(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl,
		ParentAnnotation prntAnn) =>
		if (prntAnn.pckg.empty ||
			prntAnn.pckg == decl.containingPackage.name) then
			decl.containingPackage
		else if (exists pckg = pckgCache[prntAnn.pckg]) then
			pckg
		else
			((() {
				value itr = modules.list.iterator();
				while (is Module mdl = itr.next()) {
					if (exists pckg = mdl.findPackage(prntAnn.pckg)) {
						pckgCache[prntAnn.pckg] = pckg;
						return pckg;
					}
				}
				return null;
			})());
	
	String|Exception resolveComponentChild(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists prntAnn = annotations(`ParentAnnotation`,decl)) then
			let (pckg = findParentPackage(decl,prntAnn))
			if (exists pckg) then
				if (exists parent =
					pckg
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
				Exception(
					"Component name for '``decl``' cannot be resolved. " +
					"Package '``prntAnn.pckg``' not found. ")
		else
			resolveUnbound(decl);
	
}
