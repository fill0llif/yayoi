import it.feelburst.yayoi.model {
	Named,
	ComponentMutableMap
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}
"Component representing states and behaviours shared between
 component, container and window"
shared sealed interface AbstractComponent
	satisfies
		Named&
		Hierarchical {
	"Whether or not is valid or needs to be updated"
	shared formal Boolean valid;
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
	"Display this component"
	shared formal void display();
	"Hide this component"
	shared formal void hide();
	"Component's listeners"
	shared formal ComponentMutableMap<String,Listener<Object>> listeners;
	"Invalidate this component"
	shared formal void invalidate(Boolean internal = true);
	"Validate this component (components layout and UIs)"
	shared formal void validate(Boolean internal = true);
	"Allow a visitor to visit this component"
	shared formal void accept(Visitor visitor);
}