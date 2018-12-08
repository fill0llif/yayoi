import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.model {
	Reactor
}
shared sealed class ReactorImpl() satisfies Reactor {
	
	variable Reaction<>[] rctns = [];
	
	shared actual Reaction<Type>[] reactions<Type=Object>()
		given Type satisfies Object =>
		rctns
			.narrow<Reaction<Type>>()
			.sort((Reaction<Type> x, Reaction<Type> y) =>
			x.order <=> y.order);
	
	shared actual void addReaction(Reaction<> reaction) =>
		rctns = rctns.append([reaction]);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		rctns = reactions;
}
