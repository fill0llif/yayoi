import it.feelburst.yayoi.model {
	Source
}
import it.feelburst.yayoi.model.container {
	Layout,
	MutableWithLayout
}

import java.awt {
	Container,
	LayoutManager
}
shared class SwingMutableWithLayout<Type,LayoutType>(Source<Type> source)
	satisfies MutableWithLayout<LayoutType>
	given Type satisfies Container
	given LayoutType satisfies LayoutManager {
	
	variable Layout<LayoutType>? lyt = null;
	
	shared actual Layout<LayoutType>? layout =>
		lyt;
	
	shared actual void setLayout(Layout<LayoutType>? layout) {
		if (exists layout) {
			lyt = layout;
			if (layout.val == nullLayout) {
				source.val.layout = null;
			} else {
				source.val.layout = layout.val;
			}
			log.info("LayoutManager '``layout.val``' added to SwingContainer '``source.val``'.");
		}
	}
	
}