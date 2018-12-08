import ceylon.language.meta.declaration {
	FunctionDeclaration
}

import it.feelburst.yayoi.behaviour.action {
	AbstractAction,
	LookAndFeelAction
}

import java.awt {
	Window
}

import javax.swing {
	UIManager,
	SwingUtilities {
		updateComponentTreeUI
	}
}

import org.springframework.context {
	ApplicationContext
}
shared class SwingLookAndFeelAction(
	shared actual String name,
	shared actual FunctionDeclaration decl,
	ApplicationContext context)
	extends AbstractAction(name,decl)
	satisfies LookAndFeelAction {
	
	shared actual void execute() {
		if (is String lookAndFeelName = decl.invoke()) {
			UIManager.setLookAndFeel(lookAndFeelName);
			Window.ownerlessWindows.array.narrow<Window>()
			.each((Window window) =>
				updateComponentTreeUI(window));
			log.info("Action: Look and Feel set to '``lookAndFeelName``'.");
		}
		else {
			throw Exception(
				"Cannot execute Look and Feel Action '``this.name``'. Look and Feel " +
				"must be set using a String.");
		}
	}
}