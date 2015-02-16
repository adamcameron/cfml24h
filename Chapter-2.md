# Flow control structures #

CFML has all the usual suspects when it comes to flow control structures. I'll split these into three sections:

* branching - eg: if / switch / try/catch
* looping - eg: for / while / do/while / collection iteration methods
* abstracting - eg: include files, modules, functions, classes

## Branching ##

### if ###

This is exactly the same as most "curly brace" languages:

````cfc
if (booleanExpression) statement(s) if true

if (booleanExpression) statement(s) if true
else statement(s) if false
````

The statement(s) can be either a single statement, or a block of statements:

````cfc
if (booleanExpression)
	// a single statement to run if true

if (booleanExpression) {
	// a statement to run if true
	// another statement to run if true
	// etc
}
````

This extends to `else` as well:

````cfc
if (booleanExpression)
	// a single statement to run if true
else
	// a single statement to run if false


if (booleanExpression) {
	// a statement to run if true
	// another statement to run if true
	// etc
}else{
	// a statement to run if false
	// another statement to run if false
	// etc
}
````

I agree with the common recommendation to always use curly-brace-delimited blocks, even if your block has only one statement. It makes the code clearer, and reduces the chance of unexpected behaviour:

````cfc
// this is misleading
if (booleanExpression)
	// a single statement to run if true
	// another statement, but is run whether true or false

// this is clearer
if (booleanExpression) {
	// a single statement to run if true
}
	// another statement, but is run whether true or false
````

In the latter example, it's easier to see that the indentation is just wrong, whereas in the first example it'd be easy to misread the second statement as being part of the `if` clause.

CFML doesn't specifically have an `elseif` construct (although Lucee supports it), one just combines a single-statement `else` clause which is an `if`:

````cfc
if (booleanExpression)
	// a single statement to run if booleanExpression is true
else if (differentBooleanCondition)
	// a single statement to run if differentBooleanCondition is true
else
	// a single statement to run if differentBooleanCondition is false

// or

if (booleanExpression) {
	// a statement to run if booleanExpression is true
	// another statement to run if booleanExpression is true
	// etc
} else if (differentBooleanCondition){
	// a statement to run if differentBooleanCondition is true
	// another statement to run if differentBooleanCondition is true
	// etc
}else{
	// a statement to run if differentBooleanCondition is false
	// another statement to run if differentBooleanCondition is false
	// etc
}
````

### switch ###

Switch/case in CFML works the same was as it generally does in other "curly brace" languages:

````cfc
switch (colour) {
	case "red":
		writeOutput("##FF0000");
	break;

	case "green":
		writeOutput("##00FF00");
	break;

	case "blue":
		writeOutput("##0000FF");
	break;

	default:
		writeOutput("it was some other colour");
}
````
Unlike with `if` statements, the curly braces are required with a `switch` statement.

It's important to note that once a `case` condition is matched, then all the code in the `switch` block is executed until a `break` statement is encountered: no further `case` clauses are tested. This demonstrates what I mean:

````cfc
switch (colour) {
	case "red":
		writeOutput("##FF0000");
	// no break statement here

	case "green":
		writeOutput("##00FF00");
	break;

	case "blue":
		writeOutput("##0000FF");
	break;

	default:
		writeOutput("it was some other colour");
}
````

If `colour` was `red`, then the output would be this:

````
#FF0000#00FF00
````

This is because processing skips down to the `red` case, an executes everything down to the next `break` statement, which means these lines get executed:

````cfc
writeOutput("##FF0000");
case "green":
writeOutput("##00FF00");
break;
````

A `case` is not actually the test condition, that's all handled by the `switch` statement. A `case` is merely a label.

Sometimes having this "fall through" functionality is desirable, but on the whole it's something to look out for when processing is not behaving how you'd intended it to be.

A side effect of this is that one can have one block of code executed for multiple `case`s:

````cfc
switch (colour) {
	case "red":
	case "green":
		// this will be run for either of red or green
	break;

	// etc
}
````

If you're using ColdFusion, an important thing to note is that the values for the case clauses need to be *constant* values, ie: they need to be literal values. On Lucee they can be any expression:

````cfc
// this example is only legal on Lucee

COLOURS = {
	RED = "red"
};

function returnsGreen(){
	return "yellow";
}

function sometimesReturnsBlue(){
	return randRange(0,1) ? "blue" : "not blue";
}

switch (URL.colour) {
	case COLOURS.RED:
		writeOutput("##FF0000");
	break;

	case returnsGreen():
		writeOutput("##00FF00");
	break;

	case sometimesReturnsBlue():
		writeOutput("##0000FF");
	break;

	default:
		writeOutput("it was some other colour");
}
````

Finally... in all my examples here I have specified a `default` case. This is optional, but I think generally there is grounds to have one. The `default` case is used if none of the previous cases were used.

### try/catch ###

The try/catch statement is for dealing with exceptions (runtime errors). The syntax for `try` / `catch` (and `finally`) is the same as in other similar languages:

````cfc
try {
	// code that could possibly error at runtime, or raise an exception for some other reason
} catch (ExceptionType variableToTakeException) {
	// code to deal with errors of type ExceptionType
} catch (DifferentExceptionType variableToTakeException) {
	// code to deal with errors of type DifferentExceptionType
} finally {
	// code to run after the try / catch code. This code *always* runs
}
// subsequent code
````

* If the code in the `try` block completes without error, processing continues in the `finally` block, before continuing to any subsequent code
* If the code in the `try` block errors at runtime, then the CFML engine will look for a `catch` clause to handle the exception. In the code above there are `catch` clauses which will deal with a exception of type `ExceptionType` or `DifferentExceptionType`. If the exception associated with the error is either of those, then the appropriate block of code will be executed. If any other type of exception is raised other than the ones explicitly being "caught", then the exception will *not* be caught, and will be bubbled back to the calling code, or returned as an error to the browser if not caught via some other mechanism.
* Whatever happens, the `finally` clause is always executed, *even if the exception is not caught*.

There is a special exception type one can catch: "any", which will catch any sort of exception at all:

````cfc
} catch (any e) {
	// statements
}
````

Some examples will make this more clear, hopefully:

````cfc
try {

	writeOutput("code before the error will run<br>");

	i = 1/0; // this will give a division by zero error, causing a java.lang.ArithmeticException to be raised

	writeOutput("code after the error will NOT run<br>");

} catch (java.lang.ArithmeticException e) {

	writeOutput("code in the appropriate catch block will run<br>");
	writeOutput("The exception was of type #e.type#<br>");

} catch (DifferentException e) {

	writeOutput("code in a different catch block will NOT run<br>");

} catch (any e) {

	writeOutput("Only one catch block will be run, so this is ignored<br>");

} finally {

	writeOutput("code in the finally block always runs<br>");

}

writeOutput("If the exception was caught, processing continues<br>");
````

Using Lucee as the CFML engine, this code will output:

````
code before the error will run
code in the appropriate catch block will run
The exception was of type java.lang.ArithmeticException
code in the finally block always runs
If the exception was caught, processing continues
````

Unfortunately there is no standard agreed between the vendors as to which exception various error conditions ought to raise. So on Lucee this raises a`java.lang.ArithmeticException`, but on ColdFusion it raises an `Expression` exception. So on ColdFusion, the `catch` clause would be:

````cfc
} catch (expression e) {

	writeOutput("code in the appropriate catch block will run<br>");
	writeOutput("The exception was of type #e.type#<br>");

}
````

As touched on in the sample code above, the `catch` clause defines a variable to contain details about the exception that has been caught. In the sample code I am using the variable `e`, which is kind of a de facto standard, but one can use a more meaningful variable name if so desired.

There is more to exception handling, but this chapter is only really about the flow control considerations of exception handling. Exception handling is covered in more depth in [INSERT APPROPRIATE CHAPTER HERE].


## Looping ##

Looping is really a special kind of branching: just branching back to an earlier line of code, rather than a subsequent line of code. Because execution is branching back to an earlier line of code, the same condition can be checked multiple times, effecting a logical "loop".

### for ###

There are a couple of different `for` loops: a generic indexed loop, and a for-in loop. The general approach is the same: there is a `for` statement which conditionally executes statement(s) based on criteria. If the statements following the `for` are enclosed in curly braces, all of them are executed each iteration; without braces, just the single following statement is repeated, eg:

````cfc
// single statement
for (criteria)
    // this one statement is looped
// this one is not

// multiple statements
for (criteria) {
    // this one is looped over
    // so is this and any other statements in the block
}
````

#### General purpose `for` loop ####

This is probably the most ubiquitous general looping structure, most familiarly realised as this sort of construct:

````cfc
for (i=1; i <= 10; i++){
	// code in here is executed ten times
}
````

This general `for` statement takes three separate (and optional) statements in its definition:

````cfc
for (initial; beforeEach; afterEach) statement(s)
````

* `initial`: this statement is once and only once before processing any of the rest of the code in the loop. This can be any single assignment statement.
* `beforeEach`: this is a boolean expression which is checked before each iteration (including before the first iteration) of the loop. If the expression is `true`, then the loop body is executed; if it is `false` (or `null`), processing continues *after* the `for` statement's code block. Note that if the expression is `false` from the outset, then the loop body is *not* executed even a first time. So it's possible for a `for` loop's code block to not be executed.
* `afterEach`: at the end of each iteration of the loop, this expression is evaluated. It's only evaluated at all if the `beforeEach` expression was `true`.
* `statement(s)`: the code that is repeated by the loop: either a single statement or a block of statements.

Bearing those rules in mind, the example above *could* be written like this:

````cfc
i=1;
for (;;){
	if (i > 10) break;
	// code in here is executed ten times
	i++;
}
````
(`break` exits from the loop)

It's not much of a stretch to realise that this sort of loop is not limited to simply counting over a variable and doing something with it, but that's generally what it's used for. Here's a very contrived example of looping over a file's contents and outputting it, using a generic `for` loop:

````cfc
f=fileOpen(getCurrentTemplatePath());
for (line=f.readLine();!isNull(line); line=fileIsEof(f) ? null : f.readLine()){
	writeOutput("#encodeForHtml(line)#<br>");
}
````

(This code only works on Lucee with full null support enabled, by the way: CFML by default does not support the `null` keyword).

#### Collection `for` loop ####

This is a procedural approach to iterating over a collection. The collection can be any of an array, a struct, a record set, or a delimited string. They're all handled pretty similarly, so I'll just breeze over the syntax and an example for each. Basically a loop is a loop, so there's not too much to say about each of these.

##### Array #####

The syntax here is:

````cfc
for (element in array) statements
````

Note that it's the element (value), not the index that gets passed into the loop:

````cfc
letters = ["a", "b", "c"];
for (letter in letters) {
	writeOutput(letter); // abc
}
````

##### Struct #####

Syntax:

````cfc
for (key in struct) statements
````

Unlike with arrays, for a struct it's the *key* that's passed into the loop:

````cfc
person = {firstName="Andrew", lastName="Bennett"};
for (key in person) {
	writeOutput("#key#: #person[key]#;"); // LASTNAME: Bennett; FIRSTNAME: Andrew;
}
````

The thing to remember here is that structs do not have a sense of ordering (more about this in Chatpter 3), so there is no guarantee which order the keys will come out in. In the example above, the keys come out in the reverse order that they were set.

##### Record set #####

This allows one to loop over a record set.

````cfc
for (row in recordset) statements
````

Each row is returned as a struct in this case. It is keyed on column name:

````cfc
people = queryNew(
	"id,firstName,lastName",
	"integer,varchar,varchar",
	[
		[1, "Charlotte", "Dennis"],
		[2, "Elise", "Forster"],
		[3, "Greta", "Holliday"]
	]
);
for (person in people){
	writeOutput("#person.id# #person.firstName# #person.lastName#<br>");
}
````

This outputs:

````
1 Charlotte Dennis
2 Elise Forster
3 Greta Holliday
````

##### String #####

This is currently only supported on ColdFusion. Syntax:

````cfc
for (element in string) statements
````

Here the string is treated as a comma-separated list of elements:

````cfc
numbers = "one,two,three";
for (number in numbers){
	writeOutput("#number#;"); // one;two;three;
}
````

It's important to note that the only supported delimiter is a comma.

### break and continue ###

[TBC]


### while ###

A `while` loop checks a condition before each iteration, and if the condition is true: runs the code in the block. When the code in the block is complete, processing is returned to the top of the loop (and the condition is, obviously, evaluated again). A `while` loop can possibly execute no iterations at all, if the condition is `false` to start with.

````cfc
while (booleanExpression) statement(s)
````

(as always, the `statement(s)` can be either a single statement or a block of statements). EG:

````cfc
i=0;
while (++i <= 5) {
	writeOutput(i); // 12345
}
````


### do/while ###

As opposed to its predecessor, a `do`/`while` checks the condition at the *end* of the loop. The side effect here is that the code block is always processed at least one time.

````cfc
do {
	// statement(s)
} while (booleanExpression);
````

Note that this construct requires a trailing semi-colon after the while clause. Also note that it might seem like the curly braces are needed here, but if there's only the one statement in the block, they are indeed optional, as this example demonstrates:

````cfc
i=1;
do writeOutput(i);
while (++i <= 5);
````

However I would not recommend that, as it's sufficiently unorthodox that I think it will confuse most people. Speaking for myself, I only became aware this was possible when writing this! This is much clearer:

````cfc
i=1;
do {
	writeOutput(i);
} while (++i <= 5);
````


### Collection iteration methods ###

All those previous looping constructs are very general purpose, and don't really do a great job of describing why the iteration process is being undertaken. Quite often one is looping over a collection to perform one of a subset of tasks:

* transforming the values in the collection somehow: remapping it.
* Filtering elements out of the collection based on a rule.
* Deriving a single value or different kind of value from the elemens of the collection.
* Checking if some or all of the elements of a collection meet some criteria.

When you think about it, you're seldom going to be looping over a collection for the heck of it: you're doing some data processing whilst you do it. CFML has an object-oriented and functional-programming approach to these operations. It has a series of collection-oriented methods which apply a callback (and optionally other parameters) to each element of the collection in turn, performing some operation to arrive at some end.

There's an entire section on their methods later on, but as they are control statements after a fashion, I'll mention them here. I'll go into more depth later.

For these examples I'll just show the array-specific methods. The ones for other collections are similar.

#### map() ####

The `map()` method creates a new collection, with each element somehow transformed, or with the original element used as some basis for an equivalent element in the new collection.

Here we remap an array of lowercase letters, simply creating new array which has the same letters uppercased:

````cfc
letters = ["a", "b", "c", "d"];

upperCaseLetters = letters.map(function(letter){
	return letter.ucase();
});
````

This returns a new array: `["A","B","C","D"]`

The callback actually receives three arguments:

````cfc
function(element, index, array)
````

So that's:
* each element (value);
* the index of that element;
* a reference to the entire array.

And the callback should return the value of the remapped element.

When using `map()`, the returned collection will always have the same index/keys, but with different values for the elements at that index/key.

#### filter() ####

`filter()` does what it says on the tin: it applies a filter to the collection, filtering out elements based on the logic in the passed-in callback (which, again, is applied to each element of the collection in turn).

````cfc
letters = ["a", "b", "c", "d", "e", "f"];

oddLetters = letters.filter(function(letter, index){
	return index MOD 2;
});
````

Here I am using the array index rather than the element value in the callback, and this returns a boolean value wherein `true` implies the element should be preserved in the result; `false` implies the element should be filtered out of the result. So here I am keeping the elements which have an odd index number:

````cfc
["a", "c", "e"]
````

Currently ColdFusion's implementation of `filter()` has a bug in that it only receives the value of the element, not its index nor a reference to the entire collection. So the code above will only run on Lucee. Lucee correctly implements its callback like this:

````cfc
function(element, index, array)
````

ColdFusion's one is simply implemented as:

````cfc
function(element)
````

#### reduce() ####

`reduce()` is slightly conceptually trickier than `map()` and `filter()`, which are both fairly obvious in their intent. The object of the `reduce()` method is to take a whole collection and derive one single value from it. This is achieved by applying a callback to each element of the collection - nothing different about that - but this time the callback returns the result of the previous callback call, as well as the next element in the collection. The `reduce()` method also takes an additional argument that is the initial value to pass to the first element's callback.

````cfc
letters = ["a", "b", "c", "d", "e", "f"];

lettersAsAString = letters.reduce(function(aggregatedLetters, letter){
	return aggregatedLetters & letter;
}, ""); // initial value for aggregatedLetters argument
````

This returns just a string:

````cfc
abcdef
````

This stands for more explanation perhaps. Let's follow through each iteration:

##### First iteration #####
`aggregatedLetters` = "" (it's initial value, as per the second argument of the `reduce()` call)

`letter` = "a" (the first element of the array)

So it returns `"" & "a"`, or `"a"`

##### Second iteration #####
`aggregatedLetters` = "a" (the result of the previous callback call)

`letter` = "b"

So it returns `"a" & "b"`, or `"ab"`

##### Third iteration #####
`aggregatedLetters` = "ab" (the result of the previous callback call)

`letter` = "c"

So it returns `"ab" & "c"`, or `"abc"`

##### Fourth iteration #####
`aggregatedLetters` = "abc" (the result of the previous callback call)

`letter` = "d"

So it returns `"abc" & "d"`, or `"abcd"`


(you get the picture)

So the result of one callback is what's passed into the first argument of the next callback call.

The method signature for the callback is:

````cfc
function(previous, current, index, array)
````

#### some() ####

This method is only supported on Lucee.

`some()` iterates over the collection, checking to see if an element meets some criteria (as defined by the callback). If the callback returns true, then `some()` returns `true`, and stops iterating.

````cfc
numbers = [1,2,3,4,5];

hasMultipleOfThree = numbers.some(function(number){
	writeOutput(number); // we're just outputing the current number here to see how many iterations some() does.
	return number MOD 3 == 0;
});
````
The output of this demonstrates how the iteration stops as soon as the criteria is met:

````
123
````

Because 3 is indeed a multiple of three, the callback returns `true`, and the iteration process exits. If the iteration exercise reaches the end of the collection before a callback returns `true`, the `some()` returns `false`.

The method signature for the callback is the same as you'd expect:

````cfc
function(element, index, array)
````

#### every() ####

This method is only supported on Lucee.

`all()` is kind of the inverse of `some()`. It continues iterating whilst the callback returns `true`, and exits as soon as the callback returns `false`. If it gets to the end of the collection before returning `false`, `all()` returns `true`.

````cfc
numbers = [1,2,3,4,5];

isEntirelyNumeric = numbers.every(function(number){
	writeOutput(number);
	return isNumeric(number);
});
````

Here the output demonstrates we interate over the entire array:

````
12345
````

Had any of the element values been non-numeric, `every()` would return `false` straight away.

The method signature for the callback is the same as for `some()`

````cfc
function(element, index, array)
````

## Abstracting code ##

### include files ###

### modules ###

### functions ###

### classes ###

TBC
