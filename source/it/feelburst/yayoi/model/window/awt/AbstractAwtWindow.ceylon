import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	Packed,
	Centered,
	Closed,
	Iconified,
	Maximized,
	Restored,
	TitleSet,
	RootInvalidated
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.container.awt {
	AbstractAwtContainer
}
import it.feelburst.yayoi.model.window {
	Window,
	WindowState
}
import it.feelburst.yayoi.model.window.awt {
	stateCodes,
	icnified=iconified,
	nrmal=normal,
	clsed=closed,
	mximized=maximized
}

import java.awt {
	Wndw=Window,
	Frame,
	Dialog
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
import it.feelburst.yayoi.model.visitor {

	Visitor
}
shared sealed abstract class AbstractAwtWindow<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtContainer<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	satisfies Window<Type>
	given Type satisfies Wndw {
	
	late variable WindowState<Integer> windowState = nrmal;
	
	shared actual void invalidate(Boolean internal) {
		super.invalidate(internal);
		publishEvent(RootInvalidated(this));
	}
	
	shared actual WindowState<Integer> state {
		switch (vl = val)
		case (is Frame) {
			assert (exists state = stateCodes[vl.extendedState]);
			return state;
		}
		case (is Dialog) {
			return windowState;
		}
		else {
			return windowState;
		}
	}
	
	shared actual AbstractCollection? root =>
		this;
	
	shared actual String? title {
		switch (vl = val)
		case (is Frame) {
			return vl.title;
		}
		case (is Dialog) {
			return vl.title;
		}
		else {
			return null;
		}
	}
	
	shared actual void setTitle(String title) {
		switch (vl = val)
		case (is Frame) {
			invokeLater(() {
				vl.title = title;
				publishEvent(TitleSet(this,title));
				log.debug("GUIEvent: Title '``title``' set for SwingWindow '``this``'.");
			});
		}
		case (is Dialog) {
			invokeLater(() {
				vl.title = title;
				publishEvent(TitleSet(this,title));
				log.debug("GUIEvent: Title '``title``' set for SwingWindow '``this``'.");
			});
		}
		else {}
	}
	
	shared actual void center() {
		if (!visible) {
			display();
		}
		invokeLater(() {
			val.setLocationRelativeTo(null);
			publishEvent(Centered(this));
			log.debug("GUIEvent: SwingWindow '``this``' centered.");
		});
	}
	
	shared actual void pack() {
		value vl = val;
		invokeLater(() {
			vl.pack();
			publishEvent(Packed(this));
			log.debug("GUIEvent: SwingWindow '``this``' is now packed.");
		});
	}
	
	shared actual Boolean opened =>
		state != clsed && visible;
	
	shared actual Boolean normal =>
		state == nrmal;
	
	shared actual Boolean iconified {
		switch (vl = val)
		case (is Frame) {
			return state == icnified;
		}
		case (is Dialog) {
			return false;
		}
		else {
			return false;
		}
	}
	
	shared actual Boolean maximized {
		switch (vl = val)
		case (is Frame) {
			return state == mximized;
		}
		case (is Dialog) {
			return false;
		}
		else {
			return false;
		}
	}
	
	shared actual Boolean closed =>
		state == clsed;
	
	shared actual void iconify() {
		switch (vl = val)
		case (is Frame) {
			if(!iconified) {
				if(!visible) {
					display();
				}
				invokeLater(() {
					vl.extendedState = icnified.val;
					publishEvent(Iconified(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now iconified.");
				});
			}
		}
		case (is Dialog) {}
		else {}
	}
	
	shared actual void maximize() {
		switch (vl = val)
		case (is Frame) {
			if(!maximized) {
				if(!visible) {
					display();
				}
				invokeLater(() {
					vl.extendedState = mximized.val;
					publishEvent(Maximized(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now maximized.");
				});
			}
		}
		case (is Dialog) {}
		else {}
	}
	
	shared actual void restore() {
		switch (vl = val)
		case (is Frame) {
			if(iconified) {
				if(!visible) {
					display();
				}
				invokeLater(() {
					vl.extendedState = nrmal.val;
					publishEvent(Restored(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now restored.");
				});
			}
		}
		case (is Dialog) {}
		else {}
	}
	
	shared actual void close() {
		switch (vl = val)
		case (is Frame) {
			if (!closed) {
				invokeLater(() {
					vl.extendedState = clsed.val;
					vl.dispose();
					publishEvent(Closed(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
				});
			}
		}
		else {
			if (!closed) {
				windowState = clsed;
				invokeLater(() {
					vl.dispose();
					publishEvent(Closed(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
				});
			}
		}
	}
	
	shared default actual void setExitOnClose() {}
	
	shared default actual void setDisposeOnClose() {}
	
	shared default actual void setHideOnClose() {}
	
	shared actual void accept(Visitor visitor) =>
		(super of Window<Type>).accept(visitor);
	
}
