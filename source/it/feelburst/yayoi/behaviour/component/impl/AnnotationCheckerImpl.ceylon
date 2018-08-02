import ceylon.language.meta {
	annotations
}

import it.feelburst.yayoi {
	ComponentDecl,
	ActionDecl
}
import it.feelburst.yayoi.behaviour.component {
	AnnotationChecker
}
import it.feelburst.yayoi.marker {
	ComponentAnnotation,
	ListenerAnnotation,
	ContainerAnnotation,
	WindowAnnotation,
	DoLayoutAnnotation,
	LayoutAnnotation
}

import org.springframework.stereotype {
	component
}

component
shared class AnnotationCheckerImpl() satisfies AnnotationChecker {
	
	shared actual
		ComponentAnnotation|ContainerAnnotation|WindowAnnotation|
		LayoutAnnotation|ListenerAnnotation? component(ComponentDecl decl) =>
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
	
	shared actual DoLayoutAnnotation? action(ActionDecl decl) =>
		if (exists lytAnn = annotations(`DoLayoutAnnotation`,decl)) then
			lytAnn
		else
			null;
}