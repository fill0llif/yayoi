import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"An event that reports a component has been removed from a collector"
shared class ComponentRemoved(
	shared AbstractCollection collector,
	shared AbstractComponent collected) {}
