import it.feelburst.yayoi.marker {
	collectValue,
	removeValue
}

import java.awt {
	Container,
	Component,
	Window
}
import java.awt.event {
	ActionListener,
	WindowListener
}

import javax.swing {
	JWindow,
	JFrame,
	JDialog,
	JPanel,
	JMenuBar,
	JMenu,
	JMenuItem,
	AbstractButton
}

collectValue
shared void collectAwtContainer(JFrame|JDialog|JWindow wndw,Container cnt) =>
	wndw.contentPane = cnt;

collectValue
shared void collectSwingMenuBar(JFrame|JDialog wndw,JMenuBar menuBar) {
	switch (wndw)
	case (is JFrame) {
		wndw.jMenuBar = menuBar;
	}
	case (is JDialog) {
		wndw.jMenuBar = menuBar;
	}
}

collectValue
shared void collectSwingMenu(JMenuBar menuBar,JMenu menu) =>
	menuBar.add(menu);

collectValue
shared void collectSwingMenuItem(JMenu menu,JMenuItem menuItem) =>
	menu.add(menuItem);

collectValue
shared void collectAwtComponent(Container cnt,Component cmp) =>
	cnt.add(cmp);

collectValue
shared void collectWindowListener(Window wndw,WindowListener lstnr) =>
	wndw.addWindowListener(lstnr);

collectValue
shared void collectActionListener(AbstractButton button,ActionListener lstnr) =>
	button.addActionListener(lstnr);

removeValue
shared void removeAwtContainer(JFrame|JDialog|JWindow wndw,Container cnt) =>
	wndw.contentPane = JPanel();

removeValue
shared void removeSwingMenuBar(JFrame|JDialog wndw,JMenuBar menuBar) {
	switch (wndw)
	case (is JFrame) {
		wndw.jMenuBar = null;
	}
	case (is JDialog) {
		wndw.jMenuBar = null;
	}
}

removeValue
shared void removeSwingMenu(JMenuBar menuBar,JMenu menu) =>
	menuBar.remove(menu);

removeValue
shared void removeSwingMenuItem(JMenu menu,JMenuItem menuItem) =>
	menu.remove(menuItem);

removeValue
shared void removeAwtComponent(Container cnt,Component cmp) =>
	cnt.remove(cmp);

removeValue
shared void removeWindowListener(Window wndw,WindowListener lstnr) =>
	wndw.removeWindowListener(lstnr);

removeValue
shared void removeActionListener(AbstractButton button,ActionListener lstnr) =>
	button.removeActionListener(lstnr);
