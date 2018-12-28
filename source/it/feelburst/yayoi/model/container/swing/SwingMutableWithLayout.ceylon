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
			"``name``.swingLayout",
			null,
			LateValue<LayoutType>(() {
				if (is LayoutType layt = vl.val.layout) {
					return layt;
				}
				else {
					value message =
						"SwingLayout '``vl.val.layout``' cannot be added to SwingContainer " +
						"'``name``'. Expected type '`` `interface LayoutManager`.name ``'.";
					log.error(message);
					throw Exception(message);
				}
			}),
			publishEvent);
	
	shared actual Layout<LayoutType>? layout =>
		lyt;
	
	shared actual void setLayout(Layout<LayoutType>? layout) {
		if (exists layout) {
			if (is LayoutManager layt = layout.val) {
				value val = vl.val;
				invokeLater(() {
					val.layout = layt;
				});
				lyt = layout;
				log.debug("LayoutManager '``layt``' added to SwingContainer '``vl.val``'.");
			}
			else {
				value message =
					"SwingLayout '``layout.val``' cannot be added to SwingContainer " +
					"'``name``'. Expected type '`` `interface LayoutManager`.name ``'.";
				log.error(message);
				throw Exception(message);
			}
		}
		else {
			value val = vl.val;
			invokeLater(() {
				val.layout = null;
			});
			lyt = null;
			log.debug("Null LayoutManager added to SwingContainer '``vl.val``'.");
		}
	}
	
}