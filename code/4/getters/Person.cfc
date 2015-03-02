// Person.cfc
component {

	property firstName;
	property lastName;

	function init(firstName, lastName){
		variables.firstName = arguments.firstName;
		variables.lastName = arguments.lastName;
	}

	function getFirstName(){
		writeLog("#getFunctionCalledName()#() called<br>");
		return variables.firstName;
	}

	function getLastName(){
		writeLog("#getFunctionCalledName()#() called<br>");
		return variables.lastName;
	}

}