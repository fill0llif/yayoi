import ceylon.logging {
	Priority,
	Category,
	info
}
import ceylon.time {
	Instant
}
shared void defaultWriteLog(
	Priority priority, Category category, 
	String message, Throwable? throwable) {
	value print =
		priority <= info then
			process.writeLine
		else
			process.writeErrorLine;
	print(
		"[``Instant(system.milliseconds).zoneDateTime()``] " +
		"``priority.string`` [``category.name``] ``message``");
	if (exists throwable) {
		printStackTrace(throwable);
	}
}
