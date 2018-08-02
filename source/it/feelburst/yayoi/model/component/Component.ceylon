import it.feelburst.yayoi.model {
	Source,
	Reactor
}

import java.awt {
	Container
}
"A component that can be rendered on screen within a container"
shared interface Component<out Type=Container>
	satisfies AbstractComponent&Source<Type>&Reactor
	given Type satisfies Container {}