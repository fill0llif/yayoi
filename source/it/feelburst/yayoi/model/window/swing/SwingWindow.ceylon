import ceylon.language.meta.declaration {
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration
}

import it.feelburst.yayoi.behaviour.listener.model {
	ExitOnCloseSet
}
import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.window.awt {
	AbstractAwtWindow
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
shared final class SwingWindow<out Type>(
	String name,
	ClassDeclaration|FunctionDeclaration|ValueDeclaration|Null declaration,
	Value<Type> vl,
	Anything collectValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	Anything removeValue(String cltrName,Object cltr, String cltblName, Object cltbl),
	void publishEvent(Object event))
	extends AbstractAwtWindow<Type>(
		name,
		declaration,
		vl,
		collectValue,
		removeValue,
		publishEvent)
	given Type satisfies Wndw {
	
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
		else {}
	}
	
}
