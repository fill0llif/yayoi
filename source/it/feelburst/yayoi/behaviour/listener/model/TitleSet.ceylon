import it.feelburst.yayoi.model.window {
	Window
}
"An event that reports a title has been set on a window"
shared class TitleSet(
	shared Window<Object> source,
	shared String title) {}
