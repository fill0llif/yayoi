import it.feelburst.yayoi.model.component {
	AbstractComponent
}

import org.springframework.context {
	ApplicationEvent
}
"An event that reports whether a component has been made visible or not"
shared class VisibleSet(
	shared actual AbstractComponent source,
	shared Boolean visible)
	extends ApplicationEvent(source) {}