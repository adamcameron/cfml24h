<cfscript>
try {
	writeOutput("Open a file for reading<br>");
	f = fileOpen(getCurrentTemplatePath());
	line = f.readLine();
	randRange(0,1) ? throw(type="ForcedException") : false;
} catch (ForcedException e){
	writeOutput("Deal with the exception<br>");
} finally {
	f.close();
	writeOutput("And the file is safely closed<br>");
}
</cfscript>