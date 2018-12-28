import it.feelburst.yayoi.model {
	Value,
	ComponentMutableMap
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}

import java.awt {
	Container
}

import org.springframework.context {
	ApplicationEvent
}

shared sealed class AwtContainer<out Type>(
	shared actual String name,
	Value<Type> vl,
	void publishEvent(ApplicationEvent event))
		satisfies AbstractComponent
		given Type satisfies Container {
	
	shared actual Boolean valid => 
		vl.val.valid;
	
	//DO NOT USE
	shared actual variable AbstractCollection? parent = null;
	
	shared actual Integer x =>
		vl.val.x;
	
	shared actual Integer y =>
		vl.val.y;
	
	shared actual Integer width =>
		vl.val.width;
	
	shared actual Integer height =>
		vl.val.height;
	
	shared actual Boolean visible =>
		vl.val.visible;
	
	shared actual void display() =>
		vl.val.visible = true;
	
	shared actual void hide() =>
		vl.val.visible = false;
	
	shared actual void setLocation(Integer x, Integer y) =>
		vl.val.setLocation(x, y);
	
	shared actual void setSize(Integer width, Integer height) =>
		vl.val.setSize(width, height);
	
	shared actual void invalidate(Boolean internal) =>
		vl.val.invalidate();
	
	shared actual void validate(Boolean internal) =>
		vl.val.repaint();
	
	//DO NOT USE
	shared actual void center() {}
	
	//DO NOT USE
	suppressWarnings("expressionTypeNothing")
	shared actual ComponentMutableMap<String,Listener<Object>> listeners => nothing;
	
	//DO NOT USE
	shared actual void accept(Visitor visitor) {}
	
}
