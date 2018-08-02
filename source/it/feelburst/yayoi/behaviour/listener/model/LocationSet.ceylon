import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports a location has been set on a component"
shared class LocationSet(
	shared actual AbstractComponent source,
	shared Integer x,
	shared Integer y)
	extends ApplicationEvent(source) {}