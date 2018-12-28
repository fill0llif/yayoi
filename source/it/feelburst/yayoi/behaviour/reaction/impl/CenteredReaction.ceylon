import it.feelburst.yayoi.behaviour.reaction {
	Reaction,
	Dependent,
	Independent
}
import it.feelburst.yayoi.marker {
	CenteredAnnotation
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}

"A reaction that centers the component within its container or the screen"
shared class CenteredReaction(
	shared actual AbstractComponent cmp,
	shared actual CenteredAnnotation ann,
	shared actual Independent independent)
	satisfies Reaction<AbstractComponent>&Dependent {
	
	value dependentImpl = DependentImpl(independent);
	
	shared actual void awaitIndependent() =>
		dependentImpl.awaitIndependent();
	
	shared actual void execute() {
		value center = ann.agent(cmp);
		center();
		log.debug("Reaction: Component '``cmp``' centered requested.");
	}
}
