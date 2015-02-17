<cfscript>
for (i=1; i <= 5; i++){
	writeOutput("Before continue: #i#<br>");
	continue;
	writeOutput("After continue: #i#<br>");
}
writeOutput("After loop<br>");	
</cfscript>