import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	Packed,
	Centered,
	Closed,
	LocationSet,
	ExitOnCloseSet,
	Iconified,
	Maximized,
	Restored,
	TitleSet
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}
import it.feelburst.yayoi.model.container.swing {
	AbstractSwingContainer
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
	Toolkit {
		defaultToolkit
	},
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
shared final class SwingWindow<Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	void publishEvent(Object event))
	extends AbstractSwingContainer<Type>(name,declaration,vl,publishEvent)
	satisfies Window<Type>
	given Type satisfies Wndw {
	
	value awtContainer = AwtContainer(name,vl,publishEvent);
	
	late variable WindowState windowState = nrmal;
	
	shared actual WindowState state {
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
	
	shared actual AbstractContainer? root =>
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
		value screenSize = defaultToolkit.screenSize;
		value parentWidth = screenSize.width.integer;
		value parentHeight = screenSize.height.integer;
		value x = (parentWidth - width) / 2;
		value y = (parentHeight - height) / 2;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.debug("GUIEvent: Location set at (``x``,``y``) for SwingWindow '``this``'.");
			publishEvent(Centered(this));
			log.debug("GUIEvent: SwingWindow '``this``' centered.");
		});
	}
	
	shared actual void pack() {
		value vl = val;
		invokeLater(() {
			vl.pack();
			vl.validate();
			vl.repaint();
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
					vl.extendedState = icnified.correspondence();
					vl.validate();
					vl.repaint();
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
					vl.extendedState = mximized.correspondence();
					vl.validate();
					vl.repaint();
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
					vl.extendedState = nrmal.correspondence();
					vl.validate();
					vl.repaint();
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
			internalFrameClose(vl);
		}
		case (is JDialog|JWindow) {
			internalWindowAndDialogClose(vl);
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
	
	void internalFrameClose(JFrame val) {
		if (!closed) {
			invokeLater(() {
				val.extendedState = clsed.correspondence();
				val.dispose();
				publishEvent(Closed(this));
				log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
			});
		}
	}
	
	void internalWindowAndDialogClose(JDialog|JWindow val) {
		if (!closed) {
			windowState = clsed;
			invokeLater(() {
				val.dispose();
				publishEvent(Closed(this));
				log.debug("GUIEvent: SwingWindow '``this``' is now closed.");
			});
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
		case (is JDialog) {}
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
