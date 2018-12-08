import it.feelburst.yayoi.model.window {
	Window
}
"An event that reports a window has been closed"
shared class Closed(
	shared Window<Object> source) {}
