<cfscript>
try {
	throw(
		type = "SomeException",
		errorCode = "123",
		message = "This is an exception",
		detail = "And more detail on the exception",
		extendedinfo = "More info still"
	);
}catch(any e){
	writeDump(e);
}
</cfscript>