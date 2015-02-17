<cfscript>
numbers = [1,2,3,4,5];

isEntirelyNumeric = numbers.every(function(number){
	writeOutput(number);
	return isNumeric(number);
});	
</cfscript>