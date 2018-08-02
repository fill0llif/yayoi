import ceylon.collection {
	MutableMap,
	HashMap
}

import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.component.swing {
	SwingHierarchical
}
import it.feelburst.yayoi.model.container {
	AbstractContainer,
	MutableContainer
}

import it.feelburst.yayoi.model.listener {
	Listener
}

import java.awt {
	Container
}
import java.util {
	EventListener
}

import org.springframework.context {
	ApplicationEvent
}

shared class AwtContainer<Type>(
	shared actual String name,
	Source<Type> source,
	void publishEvent(ApplicationEvent event))
		satisfies AbstractContainer
		given Type satisfies Container {
	
	value hierarchical = SwingHierarchical();
	
	value awtMutableContainer = MutableContainer();
	
	MutableMap<String,Listener<EventListener>> lstnrs = HashMap<String,Listener<EventListener>>();
	
	shared actual AbstractContainer? parent =>
		hierarchical.parent;
	
	shared actual void setParent(AbstractContainer? parent) =>
		hierarchical.setParent(parent);
	
	shared actual AbstractContainer? root =>
		hierarchical.root;
	
	shared actual Integer x =>
		source.val.x;
	
	shared actual Integer y =>
		source.val.y;
	
	shared actual Integer width =>
		source.val.width;
	
	shared actual Integer height =>
		source.val.height;
	
	shared actual Boolean visible =>
		source.val.visible;
	
	shared actual void setVisible(Boolean visible) {
		source.val.visible = visible;
		source.val.repaint();
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		source.val.setLocation(x, y);
		source.val.repaint();
	}
	
	shared actual void setSize(Integer width, Integer height) {
		source.val.setSize(width, height);
		source.val.repaint();
	}
	
	shared actual void center() {}
	
	shared actual AbstractComponent? component(String name) =>
		awtMutableContainer.component(name);
	
	shared actual AbstractComponent[] components =>
		awtMutableContainer.components;
	
	shared actual void addComponent(AbstractComponent component) =>
		awtMutableContainer.addComponent(component);
	
	shared actual void removeComponent(String name) =>
		awtMutableContainer.removeComponent(name);
	
	shared actual Listener<EventListener>[] listeners =>
		lstnrs
		.items
		.sequence();
	
	shared actual Listener<EventListener>? listener(String name) =>
		lstnrs[name];
	
	shared actual void addListener(Listener<EventListener> listener) =>
		lstnrs.put(listener.name, listener);
	
	shared actual void removeListener(String name) =>
		lstnrs.remove(name);
	
}
