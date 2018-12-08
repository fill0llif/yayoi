import ceylon.logging {
	Priority,
	Category
}
import ceylon.time {
	Instant
}
shared void defaultWriteLog(
	Priority priority, Category category, 
	String message, Throwable? throwable) {
	print(
		"[``Instant(system.milliseconds).zoneDateTime()``] " +
		"``priority.string`` [``category.name``] ``message``");
	if (exists throwable) {
		printStackTrace(throwable);
	}
}
