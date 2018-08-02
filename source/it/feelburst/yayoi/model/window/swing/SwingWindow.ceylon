import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	TitleSet,
	Packed,
	Centered,
	ExitOnCloseSet,
	Closed,
	Restored,
	Maximized,
	Iconified,
	SizeSet,
	VisibleSet,
	LocationSet,
	IndependentDoneExecuting
}
import it.feelburst.yayoi.behaviour.reaction {
	Reaction
}
import it.feelburst.yayoi.behaviour.reaction.impl {
	SizeReaction
}
import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.awt {
	AwtContainer
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
import it.feelburst.yayoi.model.container {
	AbstractContainer
}
import it.feelburst.yayoi.model.impl {
	ReactorImpl
}
import it.feelburst.yayoi.model.listener {
	Listener
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
	}
}
import java.util {
	EventListener
}

import javax.swing {
	JFrame {
		exitOnClose
	},
	SwingUtilities {
		invokeLater
	}
}

import org.springframework.context {
	ApplicationEvent
}
"Swing implementation of a window"
shared class SwingWindow<out Type=JFrame>(
	shared actual String name,
	Source<Type> source,
	void publishEvent(ApplicationEvent event))
		satisfies Window<Type>
		given Type satisfies JFrame {
	
	value awtContainer = AwtContainer(name,source,publishEvent);
	value reactor = ReactorImpl();
	
	shared actual AbstractContainer? parent =>
		null;
	
	shared actual void setParent(AbstractContainer? parent) {}
	
	shared actual AbstractContainer? root =>
		this;
	
	shared actual WindowState|Exception state =>
		if (exists state = stateCodes[source.val.extendedState]) then state
		else Exception();
	
	shared actual String title =>
		source.val.title;
	
	shared actual void setTitle(String title) {
		value srcVal = val;
		invokeLater(() {
			srcVal.title = title;
			publishEvent(TitleSet(this,title));
			log.info("Title '``title``' set for Component '``this``'.");
		});
	}
	
	shared actual Integer x =>
		awtContainer.x;
	
	shared actual Integer y =>
		awtContainer.y;
	
	shared actual Integer width =>
		awtContainer.width;
	
	shared actual Integer height =>
		awtContainer.height;
	
	shared actual Boolean visible =>
		awtContainer.visible;
	
	shared actual void setVisible(Boolean visible) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setVisible(visible);
			publishEvent(VisibleSet(this, visible));
			log.debug(
				"Component '``this``' is now " +
				"``visible then "" else "not "``visible.");
		});
	}
	
	shared actual void setLocation(Integer x, Integer y) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.info("Location set at (``x``,``y``) for Component '``this``'.");
		});
	}
	
	shared actual void setSize(Integer width, Integer height) {
		// component must load the internal component before
		// entering the AwtEvent queue
		suppressWarnings("unusedDeclaration")
		value srcVal = val;
		invokeLater(() {
			awtContainer.setSize(width, height);
			publishEvent(SizeSet(this,width,height));
			publishEvent(IndependentDoneExecuting(
				this,
				(Reaction<Object> rctn) =>
					rctn is SizeReaction));
			log.info("Size (``width``,``height``) set for Component '``this``'.");
		});
	}
	
	shared actual void center() {
		if (!visible) {
			setVisible(true);
		}
		value screenSize = defaultToolkit.screenSize;
		value parentWidth = screenSize.width.integer;
		value parentHeight = screenSize.height.integer;
		value x = (parentWidth - width) / 2;
		value y = (parentHeight - height) / 2;
		invokeLater(() {
			awtContainer.setLocation(x, y);
			publishEvent(LocationSet(this,x,y));
			log.info("Location set at (``x``,``y``) for Component '``this``'.");
			publishEvent(Centered(this));
			log.info("Component '``this``' centered.");
		});
	}
	
	shared actual void pack() {
		value srcVal = val;
		invokeLater(() {
			srcVal.pack();
			srcVal.repaint();
			publishEvent(Packed(this));
			log.debug("Component '``this``' is now packed.");
		});
	}
	
	shared actual AbstractComponent? component(String name) =>
		awtContainer.component(name);
	
	shared actual AbstractComponent[] components =>
		awtContainer.components;
	
	shared actual void addComponent(AbstractComponent component) =>
		awtContainer.addComponent(component);
	
	shared actual void removeComponent(String name) =>
		awtContainer.removeComponent(name);
	
	shared actual Listener<EventListener>[] listeners =>
		awtContainer.listeners;
	
	shared actual Listener<EventListener>? listener(String name) =>
		awtContainer.listener(name);
	
	shared actual void addListener(Listener<EventListener> listener) =>
		awtContainer.addListener(listener);
	
	shared actual void removeListener(String name) =>
		awtContainer.removeListener(name);
	
	shared actual Boolean opened =>
		state != clsed && visible;
	
	shared actual Boolean normal =>
		state == nrmal;
	
	shared actual Boolean iconified =>
		state == icnified;
	
	shared actual Boolean maximized =>
		state == mximized;
	
	shared actual Boolean closed =>
		state == clsed;
	
	shared actual void iconify() {
		if(!iconified) {
			if(!visible) {
				setVisible(true);
			}
			value srcVal = val;
			invokeLater(() {
				srcVal.extendedState = JFrame.iconified;
				srcVal.repaint();
				publishEvent(Iconified(this));
				log.debug("Component '``this``' is now iconified.");
			});
		}
	}
	
	shared actual void maximize() {
		if(!maximized) {
			if(!visible) {
				setVisible(true);
			}
			value srcVal = val;
			invokeLater(() {
				srcVal.extendedState = JFrame.maximizedBoth;
				srcVal.repaint();
				publishEvent(Maximized(this));
				log.debug("Component '``this``' is now maximized.");
			});
		}
	}
	
	shared actual void restore() {
		if(iconified) {
			if(!visible) {
				setVisible(true);
			}
			value srcVal = val;
			invokeLater(() {
				srcVal.extendedState = JFrame.normal;
				srcVal.repaint();
				publishEvent(Restored(this));
				log.debug("Component '``this``' is now restored.");
			});
		}
	}
	
	shared actual void close() {
		if (!closed) {
			value srcVal = val;
			invokeLater(() {
				srcVal.extendedState = clsed.correspondence();
				srcVal.dispose();
				publishEvent(Closed(this));
				log.debug("Component '``this``' is now closed.");
			});
		}
	}
	
	shared actual void setExitOnClose() {
		value srcVal = val;
		invokeLater(() {
			srcVal.defaultCloseOperation = exitOnClose;
			publishEvent(ExitOnCloseSet(this));
			log.info("ExitOnClose operation set for Component '``this``'.");
		});
	}
	
	shared actual ClassDeclaration|FunctionDeclaration|ValueDeclaration decl =>
		source.decl;
	
	shared actual Type val =>
		source.val;
	
	shared actual Reaction<>[] reactions =>
		reactor.reactions;
	
	shared actual void addReaction(Reaction<> reaction) =>
		reactor.addReaction(reaction);
	
	shared actual void setReactions(Reaction<>[] reactions) =>
		reactor.setReactions(reactions);
	
	shared actual String string =>
		name;
}