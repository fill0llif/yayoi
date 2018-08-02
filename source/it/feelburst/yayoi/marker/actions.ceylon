import it.feelburst.yayoi {
	ActionDecl
}
shared final sealed annotation class DoLayoutAnnotation(
	shared String container,
	shared actual String pckg = "")
		satisfies OptionalAnnotation<DoLayoutAnnotation,ActionDecl>&
		PackageDependent {}

shared annotation DoLayoutAnnotation doLayout(
	String container,
	String pckg = "") =>
		DoLayoutAnnotation(container, pckg);