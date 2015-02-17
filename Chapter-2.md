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

As I've already used a `break` in one of my examples above, I should actually explain what it does, I guess.

#### break ####

A `break` statement will exit the current loop statement, resuming processing with the first statement after the loop block:

````cfc
for (i=1; i <= 5; i++){
	writeOutput("Before break: #i#<br>");
	break;
	writeOutput("After break: #i#<br>");
}
writeOutput("After loop<br>");
````

The output here is:

````
Before break: 1
After loop
````

So processing enters the loop as per usual, but when it encounters the `break`, the loop is exited completely. Sometimes one only needs to process a loop until some certain condition is met (say: finding a value in an array), at which point in time one doesn't need to check the rest of the array, so one can break out of the loop. There is generally better ways of achieving this end, but that's the most common use case.

#### continue ####

On the other hand, `continue` simply exits from the current *iteration* of the loop, not the entire loop, eg:

````cfc
for (i=1; i <= 5; i++){
	writeOutput("Before break: #i#<br>");
	continue;
	writeOutput("After break: #i#<br>");
}
writeOutput("After loop<br>");
````

The output for this one is:

````
Before break: 1
Before break: 2
Before break: 3
Before break: 4
Before break: 5
After loop
````

Note that we hit *all* of the "before" messages - so the looping is still running - but the `continue` exits the given iteration, resuming processing at the top of the loop for the next iteration.

When would one want to do this? Say one has a an array with numbers in it. One might only want to process the array element if it is an even number, but one does want to process *all* the even numbers in the array:

````cfc
for (i=1; i <= 10; i++){
	if (i  MOD 2){ // if there's a remainder it's an odd number, so we're not interested
		continue;
	}
	// process the even number
	writeOutput(i);
}
````

In this example the output is:

````
246810
````

Right. Back to the actual looping constructs...


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

The third aspect of flow control is the various techniques of refactoring pieces of code out of the mainline code execution. One does this for one of two reasons, generally:

* code re-use
* code organisation

A well-written piece of code does one thing, and in a self-contained fashion. This facilitates refactoring that piece of code out of the mainline code into a separate file or function so the code can then be re-used in other situations where the functionality is appropriate.

Even if the code is distinctly one-use - which is often the case, and there's nothing wrong with that - refactoring out of the mainline to make the code cleaner ([SEE APPROPRIATE CHAPTER]) is still something to strive for.

Any given piece of code should do one thing. As part of doing that it might call in other code to achieve that one thing, but the detail of performing those substeps should be abstracted-out into a separate location.

CFML offers a few different ways of factoring sections of logic out of the mainline code, for re-use and organisation.

### Include files ###

The  most basic way of factoring-out code from one file into another is using `include`. `include` facilitates executing code from one file from within another file, eg:

main.cfm:
````cfc
// this code will run first
include "myInclude.cfm";
// this code will run third
````

myInclude.cfm
````cfc
// this code will run second
````

This allows us to break a large file into smaller files. Let's say we start with a single monolithic file, homepage.cfm:

````cfc
// header
// code
// takes
// 20 lines
// ...
// of code


// main body
// is
// another
// 100 lines
// ...
// of code


// and the footer
// is 10 lines
// ...
// of code
````

There's clearly three sections of code there, which quite reasonably are needed to define the  home page, but within that home page are discrete chunks of logic / mark-up. We could refactor that homepage.cfm from 130 lines of code down to three:

````cfc
include "header.cfm";
include "body.cfm";
include "footer.cfm";
````

And simply break down the code thus:

````cfc
// header.cfm
// header
// code
// takes
// 20 lines
// ...
// of code
````

````cfc
// body.cfm
// main body
// is
// another
// 100 lines
// ...
// of code
````

````cfc
// footer.cfm
// and the footer
// is 10 lines
// ...
// of code
````

So the homepage.cfm code now just describes what comprises the home page, but the implementation detail has been factored out into more  wieldy chunks. If one has to do some maintenance or enhancements to the header, one only needs to work on a smaller file with just the 20 lines of header code in it. Similarly if maintaining the main body, one focuses on just the code in body.cfm.

This also sets one up nicely for creating other pages which need the same header and footer: they can simmply include those files too.

When using `include` it is almost as if the CFML engine inserts the code from the included file into the file including it, and then executes the code as one piece. This is similar to how C implements the `#include` directive. This is not quite what happens. The CFML compiler compiles the included file separately and *before* it's included into the file including it. Then the code is executed. This means the CFML code in an included file needs to be syntactically complete so it can be compiled. Here's an example to demonstrate:

Original code:
````cfc
switch (colour){
	case "red" :
		writeOutput("FF0000");
	break;
	case "green" :
		writeOutput("00FF00");
	break;
	case "blue" :
		writeOutput("0000FF");
	break;
}
````

Attempt to refactor code:
````cfc
switch (colour){
	include "cases.cfm";
}
````

cases.cfm
````cfc
case "red" :
	writeOutput("FF0000");
break;
case "green" :
	writeOutput("00FF00");
break;
case "blue" :
	writeOutput("0000FF");
break;
````

This is illegal because neither file is left syntactically correct. Lucee gives this compile error:

````
invalid construct in switch statement
````

And ColdFision gives this (slightly clearer) one:

````
Only case: or default: statements may be immediately contained by a switch statement.
````

cases.cfm also will not compile:

````
Missing [;] or [line feed] after expression
````

(Lucee cannot even work out what the code is supposed to be doing here, so the error message is a bit misleading).

When the code *does* compile, it's important to observe that the included code will run in the same memory context as the code that includes it. So variables set in the main code will be directly available in the included file, and variables set or changed in the included file will also be available in the main code after the include completes.

EG:

main.cfm
````cfc
myVar = "set in main.cfm<br>"; // outputs "set in main.cfm"
writeOutput(myVar);

include "myInclude.cfm";

writeOutput(myVar); // outputs "updated in myInclude.cfm"
````

myInclude.cfm
````cfc
writeOutput(myVar); // outputs "set in main.cfm"

myVar = "updated in myInclude.cfm<br>";
````

The output of this is:

````
set in main.cfm
set in main.cfm
updated in myInclude.cfm
````

So throughout execution there, `myVar` is the same variable in both files. This is important to note because in all the other ways of abstracting code, the abstracted code runs in its own memory space (which is a good thing).

`include` is the most simple way of abstracting code from one file into another, but it's probably the least good way of doing so. On the whole one would seldom use `include` when writing modern code.

### Modules ###

Modules work similarly to includes, except for two main factors:

* modules use their own memory space, so their code doesn't interfere with the calling code;
* modules can be used as custom tags ([SEE APPROPRIATE CHAPTER]), indeed this is their primary use.

There's a chapter dedicated to custom tags so I will not venture further down that route just yet. The syntax for calling in a module is confusingly different from using `include`:

````cfc
cfmodule(template="myModule.cfm");
````

Because myModule.cfm is run in its own memory space, it cannot simply refer to variables in the mainline code, as they are inaccessible. So to access them, they need to be passed into the module as an attribute/value pair:

````cfc
myVar = "set in main.cfm<br>";
cfmodule(template="myModule.cfm", message=myVar);
````

I'll extend that example and show how the module runs in a different memory context:

main.cfm
````cfc
myVar = "set in main.cfm<br>";
cfmodule(template="myModule.cfm", message=myVar);

writeOutput("Value of myVar in main.cfm after myModule.cfm has run: " & myVar);

writeOutput("Value of updatedMessage in main.cfm after myModule.cfm has run: " & updatedMessage);
````

myModule.cfm
````cfc
myVarExists = isDefined("myVar");
writeOutput("Does myVar exist in myModule.cfm? [#myVarExists#]<br>");

writeOutput("Value of attributes.message in myModule.cfm: " & attributes.message);

attributes.message = "updated in myModule.cfm<br>";	
writeOutput("Updated value of attributes.message in myModule.cfm: " & attributes.message);

caller.updatedMessage = attributes.message;
````

This outputs:

````
Does myVar exist in myModule.cfm? [false]
Value of attributes.message in myModule.cfm: set in main.cfm
Updated value of attributes.message in myModule.cfm: updated in myModule.cfm
Value of myVar in main.cfm after myModule.cfm has run: set in main.cfm
Value of updatedMessage in main.cfm after myModule.cfm has run: updated in myModule.cfm
````

Notice these things:

* `myVar` only exists in main.cfm; it does *not* exist in myModule.cfm
* one passes its value into the module using an attribute, then in myModule.cfm there is a variable `attributes.message` available.
* changing the value in the module does not impact the original variable in the calling code.
* one can set variables in the calling context by using the `caller` "scope".

I'll discuss the scoping of variables later; it's sufficient to see it working at the moment.

Again, like using `include`, using `cfModule()` isn't really a great way of abstracting code. Indeed you're even less likely to use it as an approach than `include`. As I touched on above, modules are generally used for custom tags, not being called directly. BUt it's a handy example to compare the way the different memory contexts work (comparing an included file and a... "moduled"... file).

### Functions ###

We're finally in the territory of code abstraction techniques you *do* want to use. A function is the work-horse way of abstracting code for later / repetitive use. Generally one would organise one's functions into classes, but I'll get to that.

Functions abstract code into its own reusable context, giving it a name, a mechanism to pass values into the code for use, and return a value when done:

````cfc
function sumTwoNumbers(n1, n2){
	var sum = n1 + n2;
	return sum;
}

x1 = 2;
y1 = 3;

writeOutput("#x1# + #y1# = #sumTwoNumbers(x1,y1)#<br>");

x2 = 5;
y2 = 7;

writeOutput("#x2# + #y2# = #sumTwoNumbers(x2,y2)#<br>");
````

This outputs:
````
2 + 3 = 5
5 + 7 = 12
````

The function `sumTwoNumbers()` defines that it takes two arguments: `n1` and `n2` (you'd normally give more descriptive names than this!). And the body of the function simply sums those two values, and then returns them.

In the calling code we've got two pairs of completely different variables (`x1`, `y1` and `x2`, `y2`), which we pass - in turn - into `sumTwoNumbers()` as arguments. At no point does the code within `sumTwoNumbers()` refer to any variables in the calling code; and at no point does the calling code reference any variables or code in the function.

This is thing about functions: they ought to be completely encapsulated: they should only work with values being passed into them as arguments, do some processing (with no side effects anywhere else), and return the result of the processing. The calling code leverages this by calling the function with whichever values are necessary, and then using its result. The calling code doesn't need to know *how* the function does its work, it just needs to know how to call the function and to expect its result.

In this example, we could change the implementation of the function:

````cfc
function sumTwoNumbers(n1, n2){
	var sum = 0;
	sum += n1;
	sum += n2;
	return sum;
}
````

And the calling code stays the same.

Note that one *generally* wouldn't have the function defined in the main code like this, but it's just easier for the example code. And it's important to see how a function operates in its own memory context.

Do note though, how when I am declaring a new variable inside the function, I use the `var` keyword:

````cfc
var sum = 0;
````

Using the `var` keyword, the `sum` variable is made local to the function's memory context. Had I *not* used the `var` keyword, then `sum` would have been created in the calling code's memory context. This demonstrates that the code within a function *can* access variables in the maintain code, and set them too. However this should be avoided. The only values a function should use are its argument values, and other values it derives from those. It should *not* directly reference variables from its calling context. The main reason for this is that it means the function actually relies on its calling code to be able to work, which makes it less portable.

### Classes ###

The way one *should* organise one's functions is to put them into a class (for some reason CFML refers to them as "components" in their definition: but just think "class"). Like most OO languages, this is the primary way CFML organises its code, and where almost all of your code will go.

There's an entire section on CFML's OO implementation later on, I'm just doing to discuss the code-abstraction side of things here.

CFML has two different types of code file: a general script file, which just contains procedural code, with the file extension .cfm. These are the files one would use for views or for the entry point into your application. Or if indeed you just needed to write a quick test script like the code I've been listing as we go in this document. If one browses to a web-accessible .cfm file, it will execute, running the code from top to bottom.

The other file type is a CFC (.cfc extension), or "ColdFusion Component". These are not directly executable like .cfm files, they are used to define classes. A function encapsulates logic into a transportable / re-usable unit; a class encapsulates the description of a type of data (made up of properties), plus all its behaviour (methods) into one unit. The basic programming language has a sense of a string, or an array or what-have-you, but it's up to the application to define what - for example - it means to be a Person (or a Vehicle, or a Queue, etc). A Person will have properties (data values) like `firstName` and `lastName`, and it might have a method (behaviour) `getFullName()` which returns what it suggests in its name, based on the values for `firstName` and `lastName`:

````cfc
component accessors=true {
	property firstName;
	property lastName;

	function init(firstName, lastName){
		setFirstName(firstName);
		setLastName(lastName);
	}

	function getFullName(){
		return firstName & " " & lastName;
	}
}
````

And we can then use that Person class to create a Person object in our main code:

````cfc
friend = new Person("Isla", "Jeffries");

fullNameOfFriend = friend.getFullName();
writeOutput(fullNameOfFriend);
````

This outputs:

````
Ilsa Jeffries
````

Here the main code doesn't need to know anything about what it is to be a Person, all it needs to know is the method signatures for init() and getFullName(). All the rest is encapsulated away inside Person.cfc

## Summary ##
Left to its own devices, code will just execute top to bottom. Obviously that's often not going to be much use: we need to make decisions; repeat tasks; and organise our code into easy to follow, clear units of work; and re-usable elements where possible. CFML's got a lot of options to implement good clean code.

