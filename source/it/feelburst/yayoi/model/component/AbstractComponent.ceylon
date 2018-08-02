import it.feelburst.yayoi.model {
	Named
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import java.util {

	EventListener
}
"Component representing states and behaviours shared between
 component, container and window"
shared interface AbstractComponent
	satisfies Named&Hierarchical {
	"X coordinate of this component"
	shared formal Integer x;
	"Y coordinate of this component"
	shared formal Integer y;
	"Set location of this component"
	shared formal void setLocation(Integer x, Integer y);
	"Center this component within its container or the screen"
	shared formal void center();
	"This component's width"
	shared formal Integer width;
	"This component's height"
	shared formal Integer height;
	"Set size of this component"
	shared formal void setSize(Integer width, Integer height);
	"Whether the component is visible or not"
	shared formal Boolean visible;
	"Set whether the component is visible or not"
	shared formal void setVisible(Boolean visible);
	"This component's listeners"
	shared formal Listener<EventListener>[] listeners;
	"Get this component's listener by name"
	shared formal Listener<EventListener>? listener(String name);
	"Add a listener to this component"
	shared formal void addListener(Listener<EventListener> listener);
	"Remove a listener from this component"
	shared formal void removeListener(String name);
}