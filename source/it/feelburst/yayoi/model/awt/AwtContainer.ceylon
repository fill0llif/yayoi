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
	Component,
	MenuComponent,
	SystemTray,
	TrayIcon
}

import org.springframework.context {
	ApplicationEvent
}

shared sealed class AwtContainer<out Type>(
	shared actual String name,
	Value<Type> vl,
	void publishEvent(ApplicationEvent event))
	satisfies AbstractComponent
	given Type satisfies Object {
	
	shared actual Boolean valid {
		value val = vl.val;
		if (is Component val) {
			return val.valid;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			return true;
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	//DO NOT USE
	shared actual variable AbstractCollection? parent = null;
	
	shared actual Integer x {
		value val = vl.val;
		if (is Component val) {
			return val.x;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "X coordinate not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Integer y {
		value val = vl.val;
		if (is Component val) {
			return val.y;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "Y coordinate not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Integer width {
		value val = vl.val;
		if (is Component val) {
			return val.width;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "Width not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Integer height {
		value val = vl.val;
		if (is Component val) {
			return val.height;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "Height not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Boolean visible {
		value val = vl.val;
		if (is Component val) {
			return val.visible;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			return true;
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void display() {
		value val = vl.val;
		if (is Component val) {
			val.visible = true;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void hide() {
		value val = vl.val;
		if (is Component val) {
			val.visible = false;
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		value val = vl.val;
		if (is Component val) {
			val.setLocation(x, y);
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "Location setting not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void setSize(Integer width, Integer height) {
		value val = vl.val;
		if (is Component val) {
			val.setSize(width, height);
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {
			value message = "Size setting not supported for component '``name``'.";
			log.error(message);
			throw Exception(message);
		}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void invalidate(Boolean internal) {
		value val = vl.val;
		if (is Component val) {
			val.invalidate();
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void validate(Boolean internal) {
		value val = vl.val;
		if (is Component val) {
			val.repaint();
		}
		else if (is MenuComponent|SystemTray|TrayIcon val) {}
		else {
			value message = "Component '``name``' is not an AwtComponent.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	//DO NOT USE
	shared actual void center() {}
	
	//DO NOT USE
	suppressWarnings("expressionTypeNothing")
	shared actual ComponentMutableMap<String,Listener<Object>> listeners => nothing;
	
	//DO NOT USE
	shared actual void accept(Visitor visitor) {}
	
}
