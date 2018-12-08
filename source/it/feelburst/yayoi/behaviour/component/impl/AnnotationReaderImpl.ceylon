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
	SetLookAndFeelAnnotation
}

import org.springframework.stereotype {
	component
}

component
shared class AnnotationReaderImpl() satisfies AnnotationReader {
	
	shared actual
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (exists cmpAnn = annotations(`ComponentAnnotation`,decl)) then
			cmpAnn
		else if (exists cntAnn = annotations(`ContainerAnnotation`,decl)) then
			cntAnn
		else if (exists wndAnn = annotations(`WindowAnnotation`,decl)) then
			wndAnn
		else if (exists lytAnn = annotations(`LayoutAnnotation`,decl)) then
			lytAnn
		else if (exists lstAnn = annotations(`ListenerAnnotation`,decl)) then
			lstAnn
		else
			null;
	
	shared actual DoLayoutAnnotation|SetLookAndFeelAnnotation? action(
		ClassDeclaration|FunctionDeclaration|ValueDeclaration decl) =>
		if (is FunctionDeclaration decl) then
			if (exists lytAnn = annotations(`DoLayoutAnnotation`,decl)) then
				lytAnn
			else if (exists lkndflAnn = annotations(`SetLookAndFeelAnnotation`,decl)) then
				lkndflAnn
			else
				null
		else
			null;
}