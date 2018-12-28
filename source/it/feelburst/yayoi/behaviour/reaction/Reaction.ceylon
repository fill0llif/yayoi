import ceylon.language.meta {
	classDeclaration
}

import it.feelburst.yayoi.marker {
	Order
}
import it.feelburst.yayoi.model {
	Reactor
}
"A reaction arised from a component"
see(`interface Reactor`)
shared interface Reaction<out Cmpnt=Object>
	satisfies Order&Comparable<Reaction<Object>>
	given Cmpnt satisfies Object {
	"Component"
	shared formal Cmpnt cmp;
	"Reaction annotation"
	shared formal Annotation ann;
	"Reaction execution on the component"
	shared formal void execute();
	"Reaction execution order on the component"
	shared actual Integer order {
		assert (is Order a = ann);
		return a.order;
	}
	shared actual Comparison compare(Reaction<Object> other) =>
		this.order <=> other.order;
	shared actual String string =>
		"``classDeclaration(this).name``(cmp = ``cmp``,ann = ``ann``, order = ``order``)";
}
