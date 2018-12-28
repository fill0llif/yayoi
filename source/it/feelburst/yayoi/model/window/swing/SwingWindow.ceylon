import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	Packed,
	Centered,
	Closed,
	ExitOnCloseSet,
	Iconified,
	Maximized,
	Restored,
	TitleSet,
	WindowInvalidated
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.collection {
	AbstractCollection
}
import it.feelburst.yayoi.model.collection.swing {
	AbstractSwingCollection
}
import it.feelburst.yayoi.model.window {
	Window,
	WindowState
}
import it.feelburst.yayoi.model.window.swing {
	clsed=closed,
	icnified=iconified,
	nrmal=normal,
	mximized=maximized
}

import java.awt {
	Wndw=Window
}

import javax.swing {
	SwingUtilities {
		invokeLater
	},
	JWindow,
	JFrame {
		exitOnClose
	},
	JDialog
}
"Swing implementation of a window"
shared final class SwingWindow<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void addValue(Object cltr, Object cltd),
	void removeValue(Object cltr, Object cltd),
	void publishEvent(Object event))
	extends AbstractSwingCollection<Type>(
		name,
		declaration,
		vl,
		addValue,
		removeValue,
		publishEvent)
	satisfies Window<Type>
	given Type satisfies Wndw {
	
	late variable WindowState<Integer> windowState = nrmal;
	
	shared actual void invalidate(Boolean internal) {
		super.invalidate(internal);
		publishEvent(WindowInvalidated(this));
	}
	
	shared actual WindowState<Integer> state {
		switch (vl = val)
		case (is JFrame) {
			assert (exists state = stateCodes[vl.extendedState]);
			return state;
		}
		case (is JDialog) {
			return windowState;
		}
		case (is JWindow) {
			return windowState;
		}
		else {
			value message =
				"SwingWindow state cannot be retrieved. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual AbstractCollection? root =>
		this;
	
	shared actual String? title {
		switch (vl = val)
		case (is JFrame) {
			return vl.title;
		}
		case (is JDialog) {
			return vl.title;
		}
		case (is JWindow) {
			return null;
		}
		else {
			value message =
				"SwingWindow title cannot be retrieved. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void setTitle(String title) {
		switch (vl = val)
		case (is JFrame) {
			invokeLater(() {
				vl.title = title;
				publishEvent(TitleSet(this,title));
				log.debug("GUIEvent: Title '``title``' set for SwingWindow '``this``'.");
			});
		}
		case (is JDialog) {
			invokeLater(() {
				vl.title = title;
				publishEvent(TitleSet(this,title));
				log.debug("GUIEvent: Title '``title``' set for SwingWindow '``this``'.");
			});
		}
		case (is JWindow) {}
		else {
			value message =
				"SwingWindow title cannot be set. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
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
		case (is JFrame) {
			return state == icnified;
		}
		case (is JDialog|JWindow) {
			return false;
		}
		else {
			value message =
				"SwingWindow iconified state cannot be retrieved. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Boolean maximized {
		switch (vl = val)
		case (is JFrame) {
			return state == mximized;
		}
		case (is JDialog|JWindow) {
			return false;
		}
		else {
			value message =
				"SwingWindow maximized state cannot be retrieved. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual Boolean closed =>
		state == clsed;
	
	shared actual void iconify() {
		switch (vl = val)
		case (is JFrame) {
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
		case (is JDialog) {}
		case (is JWindow) {}
		else {
			value message =
				"SwingWindow cannot be iconfied. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void maximize() {
		switch (vl = val)
		case (is JFrame) {
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
		case (is JDialog) {}
		case (is JWindow) {}
		else {
			value message =
				"SwingWindow cannot be maximized. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void restore() {
		switch (vl = val)
		case (is JFrame) {
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
		case (is JDialog) {}
		case (is JWindow) {}
		else {
			value message =
				"SwingWindow cannot be restored. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void close() {
		switch (vl = val)
		case (is JFrame) {
			if (!closed) {
				invokeLater(() {
					vl.extendedState = clsed.val;
					vl.dispose();
					publishEvent(Closed(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
				});
			}
		}
		case (is JDialog|JWindow) {
			if (!closed) {
				windowState = clsed;
				invokeLater(() {
					vl.dispose();
					publishEvent(Closed(this));
					log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
				});
			}
		}
		else {
			value message =
				"SwingWindow cannot be closed. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
	shared actual void setExitOnClose() {
		switch (vl = val)
		case (is JFrame) {
			invokeLater(() {
				vl.defaultCloseOperation = exitOnClose;
				publishEvent(ExitOnCloseSet(this));
				log.info("GUIEvent: ExitOnClose operation set for SwingWindow '``this``'.");
			});
		}
		case (is JDialog) {
			invokeLater(() {
				vl.defaultCloseOperation = exitOnClose;
				publishEvent(ExitOnCloseSet(this));
				log.info("GUIEvent: ExitOnClose operation set for SwingWindow '``this``'.");
			});
		}
		case (is JWindow) {}
		else {
			value message =
				"SwingWindow default close operation cannot be set as ExitOnClose. " +
				"SwingWindow has not been constructed accordingly. " +
				"SwingWindow may be used only with JFrame, JDialog or JWindow.";
			log.error(message);
			throw Exception(message);
		}
	}
	
}
