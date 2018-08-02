import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model {
	Reactor
}
shared class ReactorImpl()
	satisfies Reactor {
	
	variable Reaction<>[] rctns = [];
	
	shared actual Reaction<>[] reactions =>
		rctns
		.sort((Reaction<> x, Reaction<> y) =>
			x.order <=> y.order);
	
	shared actual void addReaction(Reaction<> reaction) =>
		rctns = rctns.append([reaction]);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		rctns = reactions;
}