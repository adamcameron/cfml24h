<cfscript>
writeOutput("Before the test code<br>");
try {
	switch (randRange(1,4)){
		case 1:
			writeOutput("Throwing a CaughtException<br>");
			throw(type="CaughtException");
		break;
		case 2:
			writeOutput("Throwing a RethrownException<br>");
			throw(type="RethrownException");
		break;
		case 3:
			writeOutput("Throwing a UncaughtException<br>");
			throw(type="UncaughtException");
		break;
		default:
			writeOutput("Not throwing an exception<br>");
		break;

	}
} catch (CaughtException e){
	writeOutput("Caught a #e.type#<br>");
} catch (RethrownException e){
	writeOutput("Rethrowing a #e.type#<br>");
	rethrow;
} finally {
	writeOutput("This is run irrespective of anything else going on in this try / catch / finally block<br>");
}
writeOutput("After the test code<br>");
</cfscript>