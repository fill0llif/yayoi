import ceylon.language.meta {
	annotations
}
import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	FunctionDeclaration,
	ValueDeclaration
}

import it.feelburst.yayoi.marker {
	NamedAnnotation,
	Order
}
shared sealed interface AbstractCollectRemoveValueSetting
	satisfies
		Setting<Anything(Object,Object)>&
		Order&
		Comparable<AbstractCollectRemoveValueSetting> {
	shared formal actual FunctionDeclaration decl;
	shared formal actual Annotation&Order ann;
	shared default actual Anything(Object, Object) val =>
		(Object cltr, Object cltd) =>
			decl.invoke([],cltr,cltd);
	shared actual Integer order =>
		ann.order;
	shared actual Comparison compare(AbstractCollectRemoveValueSetting other) =>
		let (cltngVlsCmprs =
			collectingValuesOrder(this.decl) <=> collectingValuesOrder(other.decl))
		if (cltngVlsCmprs == equal) then
			this.order <=> other.order
		else
			cltngVlsCmprs;
	
	Integer collectingValuesOrder(FunctionDeclaration decl) =>
		decl.parameterDeclarations.indexed
		.collect((Integer index -> FunctionOrValueDeclaration prmtrDecl) =>
			if (is ValueDeclaration prmtrDecl) then
				if (exists prmtrNmd =
					annotations(`NamedAnnotation`,prmtrDecl)) then
					-1 * (index + 1)
				else
					0
			else
				0)
		.fold(0)(plus);
}
