import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"An event that reports a component has been collected by a collector"
shared class ComponentCollected(
	shared AbstractCollection collector,
	shared AbstractComponent collected) {}
