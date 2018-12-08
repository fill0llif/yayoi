import ceylon.collection {
	MutableMap,
	HashMap
}

import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}
import it.feelburst.yayoi.model.listener {
	Listener
}
import it.feelburst.yayoi.model.visitor {
	Visitor
}

import java.awt {
	Container,
	Window
}
import java.awt.event {
	ActionListener,
	WindowListener
}

import javax.swing {
	AbstractButton,
	SwingUtilities {
		invokeLater
	}
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
	
	MutableMap<String,Listener<Anything>> lstnrs =
		HashMap<String,Listener<Anything>>();
	
	//DO NOT USE
	shared actual variable AbstractContainer? parent = null;
	
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
	
	shared actual void display() {
		vl.val.visible = true;
		vl.val.validate();
		vl.val.repaint();
	}
	
	shared actual void hide() {
		vl.val.visible = false;
		vl.val.validate();
		vl.val.repaint();
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		vl.val.setLocation(x, y);
		vl.val.validate();
		vl.val.repaint();
	}
	
	shared actual void setSize(Integer width, Integer height) {
		vl.val.setSize(width, height);
		vl.val.validate();
		vl.val.repaint();
	}
	
	shared actual void center() {}
	
	shared actual Listener<Anything>[] listeners =>
		lstnrs
		.items
		.sequence();
	
	shared actual Listener<Anything>? listener(String name) =>
		lstnrs[name];
	
	shared actual void addListener(Listener<Anything> listener) {
		lstnrs.put(listener.name, listener);
		if (is AbstractButton btn = vl.val) {
			if (is ActionListener actnLstnr = listener.val) {
				invokeLater(() {
					btn.addActionListener(actnLstnr);
					log.debug("ActionListener '``actnLstnr``' added to SwingButton '``btn``'.");
				});
			}
		}
		else if (is Window wndw = vl.val) {
			if (is WindowListener wndwLstnr = listener.val) {
				invokeLater(() {
					wndw.addWindowListener(wndwLstnr);
					log.debug("WindowListener '``wndwLstnr``' added to SwingWindow '``vl.val``'.");
				});
			}
		}
	}
	
	shared actual Listener<Anything>? removeListener(String name) {
		if (exists listener = lstnrs.remove(name)) {
			if (is AbstractButton btn = vl.val) {
				if (is ActionListener actnLstnr = listener.val) {
					invokeLater(() {
						btn.removeActionListener(actnLstnr);
						log.debug("ActionListener '``actnLstnr``' removed from SwingButton '``btn``'.");
					});
				}
			}
			else if (is Window wndw = vl.val) {
				if (is WindowListener wndwLstnr = listener.val) {
					invokeLater(() {
						wndw.removeWindowListener(wndwLstnr);
						log.debug("WindowListener '``wndwLstnr``' removed from SwingWindow '``vl.val``'.");
					});
				}
			}
			return listener;
		}
		else {
			return null;
		}
	}
	
	shared actual void accept(Visitor visitor) {}
	
}
