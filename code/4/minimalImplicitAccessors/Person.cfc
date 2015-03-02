component accessors=true {

	property firstName;
	property lastName;

	function init(firstName, lastName){
		variables.firstName = arguments.firstName;
		variables.lastName = arguments.lastName;
	}

	function setFirstName(firstName){
		writeOutput("#getFunctionCalledName()#() called<br>");
		variables.firstName = arguments.firstName;
	}
	function getFirstName(){
		writeOutput("#getFunctionCalledName()#() called<br>");
		return variables.firstName;
	}

	function setLastName(lastName){
		writeOutput("#getFunctionCalledName()#() called<br>");
		variables.lastName = arguments.lastName;
	}
	function getLastName(){
		writeOutput("#getFunctionCalledName()#() called<br>");
		return variables.lastName;
	}

}