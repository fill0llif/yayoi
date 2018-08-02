import it.feelburst.yayoi.model.window {
	WindowState
}

import java.awt {
	Frame
}

shared object normal satisfies WindowState {
	shared actual Integer correspondence() => Frame.normal;
}
shared object iconified satisfies WindowState {
	shared actual Integer correspondence() => Frame.iconified;
}
shared object horizontallyMaximized satisfies WindowState {
	shared actual Integer correspondence() => Frame.maximizedHoriz;
}
shared object verticallyMaximized satisfies WindowState {
	shared actual Integer correspondence() => Frame.maximizedVert;
}
shared object maximized satisfies WindowState {
	shared actual Integer correspondence() => Frame.maximizedBoth;
}
shared object closed satisfies WindowState {
	shared actual Integer correspondence() => -1;
}

shared Map<Integer,WindowState> stateCodes = map(
	{normal,iconified,horizontallyMaximized,verticallyMaximized,maximized,closed}
	.collect((WindowState windowState) =>
		windowState.correspondence() -> windowState));
