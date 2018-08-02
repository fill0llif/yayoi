import it.feelburst.yayoi.model.component {
	AbstractComponent,
	ComponentAccessor,
	ComponentMutator
}
"Component representing states and behaviours of a container
 that can contain multiple components"
see(`interface AbstractComponent`)
shared interface AbstractContainer
	satisfies AbstractComponent&ComponentAccessor&ComponentMutator {}