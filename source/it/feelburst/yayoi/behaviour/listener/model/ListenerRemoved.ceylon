import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.listener {
	Listener
}
"An event that reports a listener has been removed from a collector"
shared class ListenerRemoved(
	shared AbstractComponent collector,
	shared Listener<Object> collected) {}
