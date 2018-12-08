import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.marker {
	LocationAnnotation
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"A reaction that sets the location of a component"
shared class LocationReaction(
	shared actual AbstractComponent cmp,
	shared actual LocationAnnotation ann)
	satisfies Reaction<AbstractComponent> {
	shared actual void execute() {
		value setLocation = ann.agentMdl(cmp);
		setLocation(ann.x, ann.y);
		log.debug("Reaction: Location set at (``ann.x``,``ann.y``) requested for Component '``cmp``'.");
	}
}
