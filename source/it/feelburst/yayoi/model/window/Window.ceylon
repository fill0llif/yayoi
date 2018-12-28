import it.feelburst.yayoi.model {
	Declaration,
	Reactor,
	Value
}

import it.feelburst.yayoi.model.visitor {
	Visitor
}
import it.feelburst.yayoi.model.collection {

	AbstractCollection
}

"A window that can be rendered on screen and can contains
 many containers, collections or components"
shared interface Window<out Type>
	satisfies
		AbstractCollection&
		Declaration&
		Value<Type>&
		Reactor
	given Type satisfies Object {
	"This window's title"
	shared formal String? title;
	"Set title of this window"
	shared formal void setTitle(String title);
	"This window's state"
	shared formal WindowState<Object> state;
	"Set exit app on close on this window"
	shared formal void setExitOnClose();
	"Whether this window is visible or it has been disposed of"
	shared formal Boolean opened;
	"Whether this window is maximized or not"
	shared formal Boolean maximized;
	"Whether this window is iconified or not"
	shared formal Boolean iconified;
	"Whether this window is neither maximized or iconified or not"
	shared formal Boolean normal;
	"Whether this window has been disposed of or not"
	shared formal Boolean closed;
	"Iconify this window"
	shared formal void iconify();
	"Maximize this window"
	shared formal void maximize();
	"Restore this window (neither iconified nor maximized)"
	shared formal void restore();
	"Close this window"
	shared formal void close();
	"Pack this window"
	shared formal void pack();
	
	shared actual void accept(Visitor visitor) =>
		visitor.visitWindow(this);
}
