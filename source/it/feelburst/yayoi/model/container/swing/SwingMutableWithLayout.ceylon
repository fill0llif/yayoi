import it.feelburst.yayoi.model {
	Value
}
import it.feelburst.yayoi.model.container {
	Layout,
	MutableWithLayout
}
import it.feelburst.yayoi.model.impl {
	LateValue
}

import java.awt {
	Container,
	LayoutManager
}

import javax.swing {
	SwingUtilities {
		invokeLater
	}
}
shared sealed class SwingMutableWithLayout<out Type,LayoutType>(
	String name,
	Value<Type> vl,
	void publishEvent(Object event))
	satisfies MutableWithLayout<LayoutType>
	given Type satisfies Container
	given LayoutType satisfies Object {
	
	late variable Layout<LayoutType>? lyt =
		SwingLayout<LayoutType>(
			"``name``.SwingLayout()",
			null,
			LateValue<LayoutType>(() {
				assert (is LayoutType layt = vl.val.layout);
				return layt;
			}),
			publishEvent);
	
	shared actual Layout<LayoutType>? layout =>
		lyt;
	
	shared actual void setLayout(Layout<LayoutType>? layout) {
		if (exists layout) {
			lyt = layout;
			assert (is LayoutManager layt = layout.val);
			invokeLater(() {
				vl.val.layout = layt;
			});
			log.debug("LayoutManager '``layt``' added to SwingContainer '``vl.val``'.");
		}
		else {
			lyt = null;
			invokeLater(() {
				vl.val.layout = null;
			});
			log.debug("Null LayoutManager added to SwingContainer '``vl.val``'.");
		}
	}
	
}