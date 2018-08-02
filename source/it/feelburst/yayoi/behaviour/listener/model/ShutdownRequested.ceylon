import org.springframework.context {

	ApplicationEvent
}
"An event that reports a shutdown of the app has been requested"
shared class ShutdownRequested(Object source)
	extends ApplicationEvent(source) {}