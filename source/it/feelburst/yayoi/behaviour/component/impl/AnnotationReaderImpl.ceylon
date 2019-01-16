import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.component {
	AnnotationReader
}
import it.feelburst.yayoi.marker {
	ComponentAnnotation,
	ListenerAnnotation,
	ContainerAnnotation,
	WindowAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation,
	LookAndFeelAnnotation,
	CollectionAnnotation
}

import org.springframework.stereotype {
	component
}

component
shared class AnnotationReaderImpl() satisfies AnnotationReader {
	
	shared actual
		ComponentAnnotation|ContainerAnnotation|CollectionAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists ann = annotations(`ComponentAnnotation`,decl)) then
			ann
		else if (exists ann = annotations(`ContainerAnnotation`,decl)) then
			ann
		else if (exists ann = annotations(`CollectionAnnotation`,decl)) then
			ann
		else if (exists ann = annotations(`WindowAnnotation`,decl)) then
			ann
		else if (exists ann = annotations(`LayoutAnnotation`,decl)) then
			ann
		else if (exists ann = annotations(`ListenerAnnotation`,decl)) then
			ann
		else
			null;
	
	shared actual DoLayoutAnnotation? action(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (is FunctionDeclaration decl) then
			if (exists ann = annotations(`DoLayoutAnnotation`,decl)) then
				ann
			else
				null
		else
			null;
	
	shared actual LookAndFeelAnnotation?
		setting(ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (is ValueDeclaration decl) then
			if (exists ann = annotations(`LookAndFeelAnnotation`,decl)) then
				ann
			else
				null
		else
			null;
}