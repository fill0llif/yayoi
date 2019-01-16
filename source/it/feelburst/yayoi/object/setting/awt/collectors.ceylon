import it.feelburst.yayoi.model {
	Collector
}

import java.awt {
	Container,
	Component,
	Window,
	Dialog,
	Frame,
	MenuBar,
	Menu,
	MenuItem,
	TrayIcon,
	PopupMenu,
	SystemTray
}
import java.awt.event {
	ActionListener,
	WindowListener
}

import javax.swing {
	JWindow,
	JFrame,
	JDialog,
	JMenuBar,
	JMenu,
	JMenuItem,
	AbstractButton
}

shared object swingWindowSwingMenuBar
	satisfies Collector<JFrame|JDialog,JMenuBar> {
	shared actual void collect(JFrame|JDialog cltr, JMenuBar cltbl) {
		switch (cltr)
		case (is JFrame) {
			cltr.jMenuBar = cltbl;
		}
		case (is JDialog) {
			cltr.jMenuBar = cltbl;
		}
	}
	shared actual void remove(JFrame|JDialog cltr, JMenuBar cltbl) {
		switch (cltr)
		case (is JFrame) {
			cltr.jMenuBar = null;
		}
		case (is JDialog) {
			cltr.jMenuBar = null;
		}
	}
}

shared object awtWindowAwtMenuBar
	satisfies Collector<Frame,MenuBar> {
	shared actual void collect(Frame cltr, MenuBar cltbl) {
		switch (cltr)
		case (is Frame) {
			cltr.menuBar = cltbl;
		}
	}
	shared actual void remove(Frame cltr, MenuBar cltbl) {
		switch (cltr)
		case (is Frame) {
			cltr.menuBar = null;
		}
	}
}

shared object swingWindowAwtContainer 
	satisfies Collector<JFrame|JDialog|JWindow,Container> {
	shared actual void collect(JFrame|JDialog|JWindow cltr, Container cltbl) {
		cltr.contentPane = cltbl;
	}
	shared actual void remove(JFrame|JDialog|JWindow cltr, Container cltbl) {
		cltr.contentPane = null;
	}
}

shared object awtWindowAwtContainer 
	satisfies Collector<Frame|Dialog|Window,Container> {
	shared actual void collect(Frame|Dialog|Window cltr, Container cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(Frame|Dialog|Window cltr, Container cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtSistemTrayAwtTrayIcon 
	satisfies Collector<SystemTray,TrayIcon> {
	shared actual void collect(SystemTray cltr, TrayIcon cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(SystemTray cltr, TrayIcon cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtTrayIconAwtPopupMenu 
	satisfies Collector<TrayIcon,PopupMenu> {
	shared actual void collect(TrayIcon cltr, PopupMenu cltbl) {
		cltr.popupMenu = cltbl;
	}
	shared actual void remove(TrayIcon cltr, PopupMenu cltbl) {
		cltr.popupMenu = null;
	}
}

shared object swingMenuBarSwingMenu 
	satisfies Collector<JMenuBar,JMenu> {
	shared actual void collect(JMenuBar cltr, JMenu cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(JMenuBar cltr, JMenu cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtMenuBarAwtMenu 
	satisfies Collector<MenuBar,Menu> {
	shared actual void collect(MenuBar cltr, Menu cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(MenuBar cltr, Menu cltbl) {
		cltr.remove(cltbl);
	}
}

shared object swingMenuSwingMenuItem 
	satisfies Collector<JMenu,JMenuItem> {
	shared actual void collect(JMenu cltr, JMenuItem cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(JMenu cltr, JMenuItem cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtMenuAwtMenuItem 
	satisfies Collector<Menu,MenuItem> {
	shared actual void collect(Menu cltr, MenuItem cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(Menu cltr, MenuItem cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtContainerAwtComponent 
	satisfies Collector<Container,Component> {
	shared actual void collect(Container cltr, Component cltbl) {
		cltr.add(cltbl);
	}
	shared actual void remove(Container cltr, Component cltbl) {
		cltr.remove(cltbl);
	}
}

shared object awtWindowAwtWindowListener 
	satisfies Collector<Window,WindowListener> {
	shared actual void collect(Window cltr, WindowListener cltbl) {
		cltr.addWindowListener(cltbl);
	}
	shared actual void remove(Window cltr, WindowListener cltbl) {
		cltr.removeWindowListener(cltbl);
	}
}

shared object swingButtonAwtActionListener 
	satisfies Collector<AbstractButton,ActionListener> {
	shared actual void collect(AbstractButton cltr, ActionListener cltbl) {
		cltr.addActionListener(cltbl);
	}
	shared actual void remove(AbstractButton cltr, ActionListener cltbl) {
		cltr.removeActionListener(cltbl);
	}
}

shared object awtMenuItemAwtActionListener 
	satisfies Collector<MenuItem,ActionListener> {
	shared actual void collect(MenuItem cltr, ActionListener cltbl) {
		cltr.addActionListener(cltbl);
	}
	shared actual void remove(MenuItem cltr, ActionListener cltbl) {
		cltr.removeActionListener(cltbl);
	}
}
