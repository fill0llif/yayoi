import it.feelburst.yayoi.model {
	Value,
	ComponentMutableMap
}
import it.feelburst.yayoi.model.component {
	AbstractComponent
}
"Component representing states and behaviours of a collection
 that can contain multiple components"
see(`interface AbstractComponent`)
shared sealed interface AbstractCollection
	satisfies
		AbstractComponent&
		ComponentMutableMap<String,AbstractComponent&Value<Object>> {}
