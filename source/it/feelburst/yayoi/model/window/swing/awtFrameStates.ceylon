import it.feelburst.yayoi.model.window {
	WindowState
}

import java.awt {
	Frame
}

shared object normal satisfies WindowState<Integer> {
	shared actual Integer val = Frame.normal;
}
shared object iconified satisfies WindowState<Integer> {
	shared actual Integer val = Frame.iconified;
}
shared object horizontallyMaximized satisfies WindowState<Integer> {
	shared actual Integer val = Frame.maximizedHoriz;
}
shared object verticallyMaximized satisfies WindowState<Integer> {
	shared actual Integer val = Frame.maximizedVert;
}
shared object maximized satisfies WindowState<Integer> {
	shared actual Integer val = Frame.maximizedBoth;
}
shared object closed satisfies WindowState<Integer> {
	shared actual Integer val = -1;
}

shared Map<Integer,WindowState<Integer>> stateCodes = map(
	{normal,iconified,horizontallyMaximized,verticallyMaximized,maximized,closed}
	.collect((WindowState<Integer> windowState) =>
		windowState.val -> windowState));
