import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.listener {
	Listener
}
"An event that reports a listener has been collected by a collector"
shared class ListenerCollected(
	shared AbstractComponent collector,
	shared Listener<Object> collected) {}
