# Built-in types #

## Typefulness ##

Firstly, CFML is loosely typed, and dynamically typed. You might hear that it's "typeless": it's not. It's very much not. So get that idea out of your head, and chide anyone who suggests it to you.


### Loosely typed ###

Loosely typed means that one doesn't need to declare a variable's type when declaring the variable. In Java (strongly typed), one might need to do this sort of thing:

````cfc
Person author = new Person("Adam", "Cameron");
````

We need to say that the author variable is going to hold a Person object. Despite that being obvious by the object one is putting in the variable. In CFML one would simply need to do this:

````cfc
author = new Person("Adam", "Cameron");
````

The CFML compiler can work out for itself that author is a `Person`. Or indeed the compiler simply doesn't care: the *runtime* can work it out.

Also - and we're crossing over into dynamic typing a bit here - a variable's type is not set in stone once it's declared. In a strongly typed language, one cannot do this:

````cfc
Colleague person = new Colleague("Aaron");
// ... later on...
person = new Friend("Brigitta");
````

The `person` variable is a `Person`, so we cannot change our mind and assign it to a `Friend` object later.

In CFML we can reassign a variable to be any type, any time we like. It's how we use the variable that matters, not what we declare it to be when first decide to create it.


### Dynamically typed ###

In a statically typed language, only certain operations are available to certain data types. For example, in Java one cannot do this:

````cfc
String x = "17";
String y = "24";

Integer product = x * y; // expecting it to be 408
````

This doesn't work because one cannot multiply strings.

CFML doesn't care. This'd work fine:

````cfc
x = "17";
y = "24";

product = x * y;
````

The CFML runtime will go "yeah, x and y have a numeric values, so I can multiply those no worries". This extends to most operations with in-build CFML types: if the runtime can make sense out of your code, it will. For example, our product variable can be used as a boolean too:

````cfc
if (product > 400)  // do something
````

Because the rules for a boolean include "any non-zero numeric value is true", then that code runs fine.


### Curate's egg ###

This is great because it cuts down on a lot of ceremonial boilerplate code, and gets on with it. It is - after all - the computer's job to sort out the menial, repetitive side of code execution, not the developers. The more code just defines what needs doing, rather than the minutiae of how it needs to be done, the better.

This can be a double-edged sword though. In a statically- and strongly-typed language, the compiler can pick up a lot of mistakes during compilation. For example it could be an accident that you used `x` and `y` in that arithmetic expression. In a strongly-typed compiler, that code wouldn't even compile, let along allow you to run it.

Another benefit here is that given all that sort of type checking is done at compile time, it means the runtime process doesn't need to do it, meaning it can be lighter-weight. Remember that code is compiled once, and its run many many many times, so it makes sense to do this sort of work once, rather than every time the code is run.

Equally an IDE's job is a lot easier in a statically-typed language, as it's easier for it to keep track of what type a variable is at any given time (as it can only ever have one type, and your code clearly states what that is. So it's hard to get it wrong!). This means the IDE can more easily be helpful at code-time by offering code hinting (eg: which methods are available to call on an object), and can highlight what will be compile errors (eg: using a numeric where a boolean is needed).

To be frank: I think the benefits of the compile-type checking are minimal in a lot of situations. If you write your code clearly in the first place, you're less likely to mess it up. In my example above "`x`" and "`y`" are terrible variable names in most situations. The variable name in no way describes what the variable holds. Even product is a poor variable name: it could equally mean the result of a multiplication, or it might be like a product from one's inventory.

Also the difference between compile-time and run-time type checking is significant in some situations, but not really so much in the environment CFML is designed for. Type-checking is a pretty quick operation compared to the latency of fulfilling an HTTP request, or grabbing data from a DB, or reading a file, etc. I mean orders of magnitude different. And the sort of job CFML code is generally doing is intrinsically going to have a bunch of that slower stuff in it, so the slight hit of doing runtime type-checking will disappear in the background noise. That's not to say there's no consideration there at all, but not one I'd be worrying about too much.

It's true that one is opened-up to a greater risk of runtime errors with runtime type checking. However your code ought to be developing using TDD (see relevant chapter), so it should a be checked for runtime validity before it's released anyhow. Even if you don't use TDD - but you should - you must still have post-fact unit test coverage to test your logic actually works, and to proof you against regressions between iterations of your code. Unit testing cannot proof against all runtime errors, but using unit testing, integration testing and end-to-end testing should reveal most issues before you release the code. And compile-time error checking is still not a panacea... there's plenty of stuff that can go wrong at run-time in strongly/statically typed code that compiles OK.

One thing CFML's loose/dynamic typing doesn't help us with at all is within the IDE. Writing Java code in Eclipse or C# code in Visual Studio is a pleasure, because the IDE can help you at every turn, and knows whenever you're writing code that won't compile. It can even write code for you in some situations. This is - for all intents and purposes - impossible with CFML. Still: I've got by for over a decade (as have really a lot of people) without IDE bells and whistles, so whilst the bells and whistles are bloody handy, it's not like one is paralysed if one doesn't have them.

Another very frustrating shortcoming of CFML is that it falls over itself to be dynamically typed. So one can have a variable containing "1P", and CFML will interpret that as "1899-12-30 13:00:00". "Dec 30 1899" is CFML's "zero" date, so ColdFusion is seeing "1p" as "1pm" there, and without the date component, assumes the zero-date for all other date parts. This is very annoying, but is an example of "dynamic typing gone mad". And this  is one of many situations in which CFML will fall over itself to misinterpret your  intent under the guise of trying to make sense of your code.

I would *love* to be able to do this in CFML:

````cfc
String definitelyAString = "";
````

And for the CFML engine to not ever try to treat it as anything other than a string. Often this is not necessary, but sometimes it would just make life easier.


## Simple vs complex types ##

A simple type is one that has only one component to it, as opposed to many parts that are internally organised (complex types). Examples of simple types are strings, numerics, dates. A complex type is something like an array or a struct. An array is a collection of ordered elements, each of which have their own value. As a simple type has only one value, one can access it directly, eg:

````cfc
firstName = "Charlie";
writeOutput(firstName); // outputs "Charlie"
````

On the other hand a complex type can either be referenced as a whole, or by individual element, eg:

````cfc
person = {firstName="Emma", lastName="Farmer"};
outputWholeName(person); // passing the entire struct
writeOutput(person.firstName); // a reference to just "Emma"
````

I'll explain arrays / structs further down, but note how with simple values there's just the one part, whereas with a complex value one can reference the entire  value, or an individual part of the value. In this case I use dot-notation to reference a struct's individual element.

Note: as a rule, simple values are passed by value-copy (ie: the entire value is duplicated); complex values are passed by reference-copy (only the reference is copied, not the value the reference points to). Except for arrays in ColdFusion (but not Lucee), which are also passed by value-copy. Also note that nothing in CFML is "passed by reference" in the definitive sense of that concept.


## Calling methods on a value ##

CFML historically was a procedural language (although this goes back a decade now), so most of its value-manipulation is done via procedural-oriented headless functions, eg:

````cfc
nameBackwards = reverse("Gina"); // aniG
````
In the current versions of CFML supported by vendor engines, the native language has finally gone OO, so one can call a method on a variable:

````cfc
name = "Harry";
nameBackwards = name.reverse(); // yrraH
````

One should aim to write as modern code as possible, so I will be advocating using methods rather than headless functions. This makes sense as the CFML one writes will be OO, so it makes for more uniform code to also use CFML's native OO features too.

A time of writing, the docs for ColdFusion are still headless-function-centric, unfortunately. However a list of all of them can be found here: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions.


## Native types ##

CFML actually has quite a number of built-in types, which all have discrete behaviour.


### Simple types ###

#### String ####

The most fundamental data type in CFML is a string. In ColdFusion any literal simple value is by default stored as a string. In Lucee a numeric literal is actually stored as a numeric (etc). However this does not make any difference in how  the value is subsequently treated.

For example, these are *all* strings:

````cfc
name = "Jim";
age = 54;
dateOfBirth = "1961-03-24";
````

To a human we have a string, a number (most likely an integer), and a date there. To ColdFusion they're all strings. And for all intents and purposes they are all strings on Lucee too:

````cfc
writeOutput(len(age)); // 2 (54 being two characters long)
````

In CFML string literal values are expressed via a value delimited by either a double-quote or a single-quote:

````cfc
firstName = "Karen";
lastName = 'Long';
````

If one needs to use one of those quotes within the string literal value, there are two options:
1. use the other delimiter
2. escape the same delimiter by doubling it up

eg:

````cfc
stringContainingDoubleQuote = 'my string has a " within it';
stringContainingDoubleQuote = "my string has a "" within it"; // the value is: my string has a  within it
````

Where possible, I just use the alternate delimiter in these situations instead of doubling it up, as it is slightly clearer.

Unlike in some other languages, there is no difference between either delimiter.

My personal preference is for using double quotes, but there is absolutely no hard & fast rule here. My rationale is simply that single quotes are more likely to be part of the string (eg: as an apostrophe), than a double-quote will be. If I was to be pedantic, I'd also observe that " is a quotation mark, but ' is actually an aporstrophe (it is *not* a single quote), so it doesn't make a great deal of sense to use an apostrophe as a quote. But as I said: that's pedantry.


##### String interpolation #####

CFML's string interpolation is performing using the `#` ("hash" or "pound-sign", depending on which vagary of English you speak) character:

````cfc
firstName = "Michelle";
greeting = "G'day #firstName#";
writeOutput(greeting); // G'day Michelle
````

In CFML one can have any expression at all between the delimiting `#` characters, provided it resolves to a string, or can be coerced into a string:

````cfc
writeOutput("Today is #now().dateFormat("dddd, d mmmm yyyy")#"); // Today is Saturday, 24 January 2014
````

Notice in the expression above I can use double-quotes quite happily even though the string delimiter in this case is itself a double quote. This is valid because the expression is evaluated as a separate unit to the output of the string.

An example of type-coercion here would be this:

````cfc
writeOutput("Today is #now()#"); // Today is Today is {ts '2015-01-24 14:30:30'}
````

`now()` returns a date, but to interpolate it, the expression's value needs to be a string, so CFML will automatically convert the date into a string (resulting in that rather unwieldy "{ts '2015-01-24 14:30:30'}"). This demonstrates CFML's automatic casting can be a bit "generic", hence using `dateFormat()` in the first example  to make the output more human readable. As you probably worked out `dateFormat()` converts a date object to a string, using the argument as a formatting string.

Note that CFML cannot automatically coerce any aribitrary type back to a string. It won't coerce an array or a struct, for argument's sake:

````cfc
person = {firstName="Nigel", lastName="Olsen"};
writeOutput("Candidate's name is #person#");
````

This yields a runtime exception along the lines of:

> Can't cast Complex Object Type Struct to String

It would be reasonable if CFML automatically coerced a struct or array into - for example - JSON if one tries to use one as a string, but this has yet to be implemented.

To use a literal `#` character in a string, simply escape it by doubling it:

````cfc
writeOutput("CFML uses ## as its string interpolation delimiter"); // CFML uses # as its string interpolation delimiter
````

Documentation for string methods can be found:

1. ColdFusion: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions#Usingthememberfunctions-SupportedStringmemberfunctions

2. Lucee: has different options, but at present I do not have a link to the docs for its variations.


##### Comparing strings #####

One can use comparison operators (ie:  `==`, `>`, `<=` etc) to compare strings:

````cfc
s1 = "lower";
s2 = "upper";

if (s1 < s2) {
	// and it is, so this block will run
}
````

This can cause issues in a couple of ways. Because of CFML's loose typing, it has to guess what the operand's types are. In the case above, they're definitely both strings. But CFML will get it "wrong" in this situation:

````cfc
s1 = "7";
s2 = "007";

writeOutput(s1 == s2); // TRUE
````

However when comparing *strings*, those two are not the same. To force CFML to compare strings *as strings*, then use the `compare()` function:


````cfc
s1 = "7";
s2 = "007";

writeOutput(s1.compare(s2)); // 1
````

`compare()` returns `-1`, `0` or `1` depending on whether the first string is less than, equal to or greater than the second string. Note that the result from `compare()` *cannot* clearly be used in a boolean condition because the `less than` (`-1`) and `greater than` (`1`) results equate to a boolean `true`, and the `equals` (`0`) result equates to boolean `false`. This can be misleading:


````cfc
s1 = "7";
s2 = "007";

if (s1.compare(s2)){
	// they're NOT equal
}else{
	// they ARE equal
}

````

This is one situation in which it's better to be explicit:

````cfc
s1 = "7";
s2 = "007";

if (s1.compare(s2) == 0){
	// they're equal
}else{
	// they're NOT equal
}

````

Comparisons are done lexically, according to the strings' characters' char codes. This can lead to misleading results with accented characters, as their char codes are all higher than the unaccented characters. EG:

````cfc
s1 = "é";
s2 = "z";

writeOutput(s1 < s2); // false
writeOutput(s1.compare(s2)); // 1
writeOutput("#asc(s1)# #asc(s2)#"); // 233 122
````

Obviously (?) in a human-based collation order, `é` falls within the vicinity of `e`, not well after `z`.

Also note that doing comparisons with the comparison operators does a case-*in*sensitive comparison, whereas `compare()` is case-sensitive. To do a case-insensitive comparison using string comparisons, use `compareNoCase()`.


##### Common string methods #####

CFML has a large number of string methods, and they're all well documented so I won't go over all of them here. However here's a summary of some common ones:

````cfc
// find a substring
haystack = "string";
needle = "in";
position = haystack.find(needle); // 4

// replace a substring
base = "string";
original = "in";
replacement = "un";
updated = base.replace(original, replacement); // strung

// length
string = "sample";
length = string.len(); // 6

// left() / right() / mid()
string = "left bit middle section right end";
leftBit = string.left(8);  // left bit
middleBit = string.mid(10, 14); // middle section
rightBit = string.right(9); // right end

// trim()
padded = "   actual value here   ";
trimmed = padded.trim(); // actual value here

// ucase() / lcase()
mixedCase = "A Sample String";
uppercase = mixedcase.ucase(); // A SAMPLE STRING
lowercase = mixedcase.lcase(); // a sample string
````

Note that in CFML, the offset values are 1-based not 0-based. The first character of a string is in position 1, not position 0.

As I mentioned above, there are a *lot* more string methods than that: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions#Usingthememberfunctions-SupportedStringmemberfunctions


##### Strings as delimited lists #####

CFML has a concept of a "list" which is sometimes mistaken for a discrete data type. It is not, it is simply a series of functions which deal with delimited strings. EG:

````cfc
letters = "a,b,c,d"; // a list with four elements:a, b, c and d. The delimiter is a comma
writeOutput(letters.len()); // 7
writeOutput(letters.listLen()); // 4

writeOutput(letters.listGetAt(2)); // b

writeOutput(letters.find("c")); // 5
writeOutput(letters.listFind("c")); // 3
````

A list is a string. List functions compartmentalise strings via treating character(s) as an element delimiter rather than part of the data. By default the delimiter is a comma, however all list methods will accept a string argument which can specify alternative delimiters. Each character in the string is treated as a discrete delimiter:

````cfc
letters = "a|b/c-d";
writeOutput(letters.listLen("|/-")); // 4
````

List functions *can* be useful with some pre-existing data structures though. For example to extract the file name from a path, one could do this:

````cfc
path = "/path/to/file.cfm";
fileName = path.listLast("/"); // file.cfm
````

Lists have been popular in the past, but are restrictive and slow performers. If you want to use a compound data type, generally an array would be a better fit. Try to restrict usage of list functionality to converting a string to an array, and then performing other manipulation on the array.


##### Regular expressions #####

CFML has pretty good regular expression support. Regex patterns are not discrete objects, but are just strings which are passed to a relevant method, eg:

````cfc
heading = "this is a heading";
titleCase = heading.reReplace("((?:^|\s))(.)", "\1\U\2\E", "all"); // This Is A Heading
````

(that pattern is not foolproof, I know, but it demonstrates the point).

CFML has three main regular expression methods:
- `reFind()`
- `reReplace()`
- `reMatch()`

Those are call case sensitive. There are specific case-insensitive variants too:
- `reFindNoCase()`
- `reRelaceNoCase()`
- `reMatchNoCase()`

It is outside the scope of this book to teach regular expression usage. I have however blogged about regular expressions in CFML fairly thoroughly: http://blog.adamcameron.me/2015/01/regular-expressions-in-cfml-link-summary.html


##### CFML strings are Java Strings ######

CFML is a JVM-based language, and CFML compiles down to Java byte code. CFML strings are simply wrappers for java.lang.String objects. One can call any Java String method on a CFML string natively, eg:

````cfc
string = "this is a string";
letters = string.toCharArray(); // ["t","h","i","s"," ","i","s"," ","a"," ","s","t","r","i","n","g"]
````

Here `toCharArray()` is not a CFML method, it's a native Java one.


##### Documentation for string methods #####

1. ColdFusion: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions#Usingthememberfunctions-SupportedListmemberfunctions
2. Java: http://docs.oracle.com/javase/8/docs/api/java/lang/String.html


#### Numeric ####

Natively CFML does not distinguish between integer numbers and floating point ones: it's just got "numeric". Under the hood, these are java.lang.Double objects by default. Well: *by default* on ColdFusion they're strings until they need to be used as a numeric, really:

````cfc
pi = 3.14;
writeOutput(pi.getClass().getName()); // java.lang.String
pi += 0;
writeOutput(pi.getClass().getName()); // java.lang.Double
````

On Lucee the `pi` variable is a Double from the outset.

There's not much more to say about numeric values. As per the example above, the syntax for declaring a numeric literal is simply to type it as is:

````cfc
answer =  42;
````

There is no syntax variation to express a literal float as opposed to an integer as there is in some languages.


#### Date ####

Dates in CFML represent a date accurate to the millisecond. There is no literal way to declare 
a date in CFML, one needs to use a function which returns one, eg:

````cfc
d = createDate(2011,3,24);
d = now();
d = lsParseDateTime("24/3/2011");
````

Due to CFML's aggressive type coercion, one can generally get away with using a well-formatted string in place of a date object in any situation expecting a date. For example this works:

````cfc
dateAsString = "2011-03-24";
followingDay = dateAdd("d", 1, dateAsString); // the date 2011-03-25
````

In the past I strongly recommended against ever using a string when a date was expected, but I have softened on this now. Provided one uses an unambiguous string format, I think it's fine. Note that the format mm/dd/yyyy which people from the United States might use is *not* unambiguous. A reader from USA would think 09/11/2001 is that terrible day we will never forget. However to me - and most people from outside USA in the English-speaking world, that date is November 9, not September 11. It all depends on your locale as to which way round the `d` and the `m` components are considered. If using a string, use some subset of `yyyy-mm-dd  HH:mm:ss`.


##### ODBC date objects #####

CFML has some functions (`createOdbcDate()` etc) to support ODBC-styled date objects ostensibly intended to be used when connecting to ODBC data sources. Neither Lucee nor ColdFusion use ODBC any more (and haven't for over a decade), so these functions are pointless. Data sources all use JDBC these days, and a CFML date object will pass seamlessly through JDBC to the DB. Don't use the ODBC-oriented functions.


##### Localised values #####

CFML has a number of date formatting functions which return strings, eg: `dateFormat()`. These return USA-centric values, and are no good for internationalised sites. All output should be locale-aware, so do not use functions like `dateFormat()`, `parseDateTime()`. Use the localised equivalents: `lsDateFormat()`, `lsParseDateTime()`.


##### Unexpected behaviour #####

When it comes to dates, CFML's aggressive type coercion can be dangerous, and lead to unexpected results. For example `0` is a "valid" date, it will be considered `1899-12-31` which is the zero-date as far as CFML is concerned. Equally `1p` will be interpretted as `1pm` on that date. This is seldom what one wants, so if one starts seeing odd behaviour around dates, check what values you're using.


##### Common date methods #####

````cfc
dateToday = now(); // 2015-01-25

dateTomorrow = dateToday.add("d", 1); // 2015-01-26
oneMonthAgo = dateToday.add("m", -1); // 2014-12-25

weeksBetween = oneMonthAgo.diff("w", dateTomorrow); // -4

currentHour = dateToday.hour(); // 14

ordinalDayOfWeek = dateToday.dayOfWeek(); // 1 (Sun=1, ... Sat=7)

dateAsString = dateToday.lsDateFormat("full"); // Sunday, 25 January 2015

weekOfYear = dateToday.datePart("ww"); // 5
````

As with strings, there are a lot more methods that just those: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions#Usingthememberfunctions-SupportedDatememberfunctions


#### Boolean ####

Boolean values in CFML are one of the following three variations:

1. true / false
2. "yes" / "no" (note that those are strings, not keywords)
3. [any non-zero numeric] / 0

ColdFusion boolean functions return the `"yes"` / `"no"` variation. Lucee, more properly, returns `true` / `false`. One should never compare the actual value of a boolean in a conditional statement, as the conditional will do this automatically. EG:

````cfc
// do this
if (isDate(someDateValue)) {
    // etc
}

// do not do this
if (isDate(someDateValue) == true) {
    // etc
}
````

This guidance extends to less obvious situations too:

````cfc
// do this
if (someArray.len()){
    // etc
}

// do not do this
if (someArray.len() > 0){
	// etc
}
````

Any non-zero numeric value is *intrinsically* true, so there's no need to check the length of the array is greater than zero. Just that it has length at all is sufficient here.


### Complex types ###

#### Array ####

The workhorse complex type in CFML is the array. An array is an ordered collection of elements, where each element is any type of data. Some languages require each array element to be of the same type: not so in CFML. Also the size of the array is dynamic, and the array will grow as needs must. There is no requirement to define the length of the array when declaring it.

Arrays can be declared using array literal syntax:

````cfc
weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
````

It's very important to remember that arrays in CFML start from index `1`, not `0`. This is a slightly contentious issue given the continued popularity of `0` as the starting index for array type collections. In my opinion CFML gets it right, and the reasons most other languages - especially newer ones - persist using `0` are both anachronistic and illogical.

Internally, on both Lucee and ColdFusion arrays are implemented as `java.util.AbstractList`s.

There is no concept of multi-dimensional arrays in CFML, but one can easily have arrays-of-arrays, which generally amount to the same thing:

````cfc
magicSquare = [
	[4,9,2],
	[3,5,7],
	[8,1,6]
];
````

Individual array elements are referenced via array notation:

````cfc
firstRow = magicSquare[1]; // [4,9,2]
secondElementOfThirdRow = magicSquare[3][2]; // 1
````

##### When to use an array #####

Arrays are for ordered collections of - somehow - related things, where there are two collective criteria:
* there is a sense of order; a first element comes before a second element, and so on;
* there is no meaningful or usage difference between elements *other than* their sense of ordering.

For a data structure to be appropriate to be implemented as an array, the order of each element in the collection is significant. IE: one element in the collection could be considered "first", another "last", and there's - for example - as sense that the third element somehow comes after the second element in the sequence. There should be no difference - from the underlying collection's perspective - between the elements of the array beyond that. That sounds a bit vague, and perhaps an example of what should *not* be treated as an array might make it clearer.

Consider my full name: Donald Adam Cameron. There's a definite sequence there: first name, middle name, last name, so one *might* think:

````cfc
fullName = ["Donald", "Adam", "Cameron"];
````

However a name is not a good example of array data. Whilst the individual names have a sequence, each part of a name does have a slightly different usage, and not all of them have equal "weighting". Especially with me, everyone uses my second name, unless I'm in trouble (with Mum, in which case I have a single name, written in capital letters, followed by an exclamation mark: "DONALD ADAM CAMERON!"), or in official capacities where I'm known as "Donald". *I* use both. And "Cameron" is a family name, and has a different usage to the first two names. Even if you're not a weirdo like me and don't really use (or even *have*) middle names, the same applies: the usage of a person's first name and last names differ. So: not an array. In a decent implementation a name would be represented by a Name object, or a struct:

````cfc
fullName = {
	firstName = "Donald",
	middleName = "Adam",
	lastName = "Cameron"
};
````

This is still a collection, but as each element has different significance, and can be treated accordingly.

So what *is* an array?

Sticking with the `name` metaphor, perhaps an array of middle names? My son has two middle names (not my decision, but that's a story for another day):

````cfc
fullName = {
	firstName = "Zachary",
	middleNames = ["Daniel", "Alexander"],
	lastName = "Cameron Lynch"
};
````

Here the middle names are distinct from the first and last names, but the differentiator from one middle name to the next is simply which order they fall in.

Or perhaps we're developing a localised system wherein the usage order of a name isn't always "given name(s) followed by family names". In some cultures the family name comes first. So our object might become:

````cfc
fullName = {
	firstName = "Zachary",
	middleNames = ["Daniel", "Alexander"],
	lastName = "Cameron Lynch",
	displayOrder = ["firstName", "middleNames", "lastName"]
};
````

One cliched metaphor is that of an `Order` (in the commercial sense of that idea): a bill of goods. An Order unto itself would be an object (or struct, but an object would be better), but within that Order there is a collection of order lines: each line item. The line items unto themselves are the exactly the same kind of thing from the perspective of the Order, but they also have a sense of sequence. An `Order` might be like this:

````cfc
order = {
	number		= 3,
	recipient	= "Adam",
	items		= [
		{sku=5, count=7, price=11.13},
		{sku=17, count=19, price=23.29}
	]
};
````

Here the order is a struct, and *each* item is also a struct, but the collection of items is an array.

As a rule of thumb, if a collection element can be given a meaningful label that distinguishes it from other elements of the collection, then the collection is not an array.


##### Sparse arrays #####

Not all array elements need to be populated:

````cfc
letters = ["a"];
letters[3] = "c"; // this also demonstrates assigning a value to an array element
````

This results in an array with an empty element, which could possibly be depicted as:

````cfc
letters = ["a", , "c"]; // note, this is not valid CFML syntax: one cannot omit array elements in an array literal
````


In CFML, the second element here - `letters[2]` - simply isn't defined. EG:

````cfc
writeOutput(letters[2]);
````

This will yield a runtime exception:

> Element at position [2] doesn't exist in array

One can test for an element's existence:

````cfc
if (letters.isDefined(2)){
	writeOutput(letters[2]);
}
````

I would say that if you find yourself creating a "sparse array" (wherein not all elements are defined), then an array might not really be the best choice to store your data. However this situation will legitimately crop up every now and then. But it's worth questioning yourself if you think a sparse array is the correct approach.


##### Common array methods #####

````cfc
letters = ["b"];
letters.prepend("a"); // ["a", "b"]
letters.append("c"); // ["a", "b", "c"]

letters.deleteAt(3); // ["a", "b"]

letters.len(); // 2

letters = ["a", "b", "c", "d", "e"];
slice = letters.slice(2,3); // ["b", "c", "d"]

slice.sort("text","desc"); // ["d", "c", "b"]

index = slice.find("b"); // 3
````

There are a lot of array methods: these are just a few of the more commonly used ones. See docs: https://wikidocs.adobe.com/wiki/display/coldfusionen/Using+the+member+functions#Usingthememberfunctions-SupportedArraymemberfunctions


#### Structs ####

Structs are another compound type, and indeed I demonstrated one above when discussing names:

````cfc
fullName = {
	firstName = "Donald",
	middleName = "Adam",
	lastName = "Cameron"
};
````

Structs represent collections wherein the elements have a sense of a name (or a label, or a key), and a value. The example above demonstrates the literal notation for defining a struct. 

* The struct is delimited with curly braces (`{` and `}`);
* each element is defined as a key and a value;
* subsequent elements are separated from the former element with a comma.

There's two significant differences between structs and arrays:

1. each element has a name / key / label rather than simply a numeric index;
2. there is no sense of any ordering between struct elements.

The first point there is obvious, and doesn't require any further expansion.

The second point does tend to catch people out: a struct's keys are not ordered. Obviously if one is to iterate over a struct, then each key/value pairing needs to be exposed in turn, and in a given system that ordering might be predictable: it might be the order the pairs were added to the struct, or it might be in alphabetical order by key name. Or some other sequence. The thing is there's no standard, so the ordering of struct keys cannot be relied on. This is at odds with how humans think about such things. In the name example above, "clearly" there's a sense that the `firstName` comes first, the `middleName` comes next, rounded out by the `lastName`. But that's a human conceit, and a struct does not care about that. Whilst it's entirely possible to iterate over a struct, with each step exposing the "next" key/value pair, structs are generally designed to be accessed directly via specific key. I guess this is a difference between structs and arrays. Arrays are *not* generally accessed via specific index; they are treated as an entire collection. Whereas a struct *is* accessed directly, and generally (*generally*) not iterated over.


##### Syntax variations  #####

There are a few different syntax notation styles for accessing struct elements. I have already mentioned these in the section on variables, so I will just summarise them here.


###### Dot notation ######

EG: `struct.key`

This is the simplest notation, and provided the struct key is known at code-time, and adheres to simple-variable-naming rules, would be the recommended way of accessing a struct's element. It can be used for both setting and getting the key's value:

````cfc
fullName = {};
fullName.firstName = "Peter";  // sets the firstName key to contain "Peter"
writeOutput(fullName.firstName); // outputs the value for the element with key "firstName"

````

One consideration here is that as CFML is not case-sensitive (`FULLNAME.FIRSTNAME` is the same as `fullname.firstname`, and is the same as `fUlLnAmE.fIrStNaMe`), there is no guarantee as to the casing of the key when it is first declared using this notation. That assignment statement will result in the fullName struct containing a key `FIRSTNAME`, because CFML upper-cases struct key names when dot notation is used. This is because of slightly performance considerations when accessing the keys later. So if key-case is important - for example the struct will be shared with a case-sensitive language like JavaScript - don't use dot notation for *setting* struct keys.


###### Bracket / Associative array notation ######

EG: `struct["key"]`

This is a more flexible notation, and has a couple of benefits over dot notation.

Firstly, the key name doesn't need to be known at code-time. Because the key name is a string, it can be a runtime value, eg:

````cfc
keyName = "firstName";
writeOutput(fullName[keyName]); // using the above example, this outputs "Peter"

````

The key can be a variable, an expression which evaluates to a string, or a string-literal.

Secondly, when using associative array notation, they casing of the key is preserved. This is useful when creating data which will be shared with case-sensitive systems. EG:

````cfc
fullName = {};
fullName.firstName = "Rosie";
fullName["lastName"] = "Smith";

fullNameAsJson = serializeJson(fullName); // {"FIRSTNAME":"Rosie","lastName":"Smith"}
````


##### Struct literal declaration considerations #####

By default struct-literal notation uses the dot-notation rules for key names. If one wants to preserve case in a key name, or use non-simple key names, simply use strings instead of literals for the key names:

````cfc
dynamicKeyName = "thisIsTheKeyName";
someStruct = {
	caseInsensitiveKey = true, // key will be CASEINSENSITIVEKEY
	"caseSensitiveKey" = true, // key will remain caseSensitiveKey
	"#dynamicKeyName#" = true, // key will be thisIsTheKeyName
	"!€##☆" = true // key will be !€#☆
}
````


##### Common struct methods #####

````cfc
person = {firstName="Tina", lastName="Underwood"};

keys = person.keyArray(); // ["firstName", "lastName"]
hasMiddleName = person.keyExists("middleName"); // false
numberOfKeys = person.count(); // 2
````


#### Record sets ####

A record set or a query is the standard data structure CFML uses to return database query data (hence it being generally - but incorrectly in my opinion - being referred to as a query object). It's also used for some other data-querying operations such as directory listings or LDAP queries and the like.

A record set is a collection of numerically indexed rows, with each row having a fixed list of string-labelled columns. Similar to a table in the database, or an array of structures (except each structure has the same set of keys).

An example might be:

````cfc
people = queryNew("id,firstName,lastName", "integer,varchar,varchar", [
	[1, "Wendy", "Xiang"],
	[2, "Yvette", "Ziegler"],
	[3, "Angela", "Brown"],
	[4, "Carol", "Davis"]
]);
````
Which is represented as:

<table border="1">
<thead><tr><th>&nbsp;</tg><th>id</th><th>firstName</th><th>lastName</th></tr>
</thead>
<tbody>
<tr><td>1</td><td>1</td><td>Wendy</td><td>Xiang</td></tr>
<tr><td>2</td><td>2</td><td>Yvette</td><td>Ziegler</td></tr>
<tr><td>3</td><td>3</td><td>Angela</td><td>Brown</td></tr>
<tr><td>4</td><td>4</td><td>Carol</td><td>Davis</td></tr>
</tbody></table>


##### Syntax #####

Note that there is no literal syntax for creating a recordset object: one must use the `queryNew()` function. Generally one would not want to create a literal record set anyhow: they are the results of calls to external resources (DB, file system, directories, etc).

To access an individual element from a recordset, one references via this syntax:

````cfc
firstNameOfThirdRecord = people.firstName[3];  // Angela
lastNameOfFourthRecord = people["firstName"][4];  // Davis
````

So this basically follows the same syntax as general variable access: dot-notation for simple or code-time column references; associative array notation for complex or runtime column references.

individual elements can, likewise, be set using the same syntax:

````cfc
people.id[1] = 5; // that row becomes 5, Wendy, Xiang
````


##### Common record set functions #####

The results of these are fairly self-explanatory

````cfc
people.addRow([
	[6, "Frances", "Gosling"],
	[7, "Hannah", "Ingalls"]
]);  // adds two new rows to the end of the record set

people.addColumn(
	"middleName",
	"varchar",
	["Julia", "Kim", "Lisa", "Melanie", "Nollaig", "Odette"]
); // adds a new column, specifying the values for each row

recordForAngela = people.getRow(3); // {id=3, firstName="Angela", middleName="Lisa", lastName="Brown"}

firstNames = valueList(people.firstName); // Wendy,Yvette,Angela,Carol,Frances,Hannah
````

Notes:
* At time of writing, Lucee has not yet implemented the `getRow()` method.
* Note the non-standard way of referencing a column when using `valueList()`. It's a static value, and must reference the query and the column name, using dot notation. At time of writing, only the headless function has been implemented; there is no OO method for this (on either Lucee or ColdFusion).


#### Functions ####

It's important to be aware that functions are a data types as well. Other data types are more obviously representations of actual *data*, however functions can also be values used in expressions, or the results of expressions, just like any other data type.

Being able to use functions as/in expressions is one of the more powerful features of CFML. Functions can be declared in one of two ways: via a function statement, or as a literal expression:

````cfc
// via fuction statement
function f(x){
	// do something with x
}
````
Declaring a function this way creates a named function `f`, and a variable `f` which contains a reference to the function.

````cfc
// via function literal
f = function (x){
	// do something with x
}
````

Declaring `f()` this way only creates the reference `f`; it does not create the named function. Accordingly, functions creatred this way are generally known as anonymous functions.

What's the difference? Well it comes down to when the code is processed. Function statements are processed at compile time, and function literals (or function expressions) are processed at runtime. This has ramifications as to how external variables the function code references are bound. Basically with function created via a statement, external variable references are bound purely by name because that's the best they can do at the time: no actual variable instances exist at compile time after all, and there's no sense of the context the function will be used. With function literals external variables are bound to the actual variable being referenced, and this binding "sticks" for the life of the function. This is known as "closure" - it's said the function "closes over" the variable.

Note that function literals can be used in any expression where a function is expected, eg:

````cfc
newArray = array.map(function(element){
	// do stuff to the element
	// return updated element
});
````

The `map()` method expects a function as its argument, and here we're using a function-literal to define the function as an inline expression in the call to `map()` itself. This makes sense in situations where the function is being used in a one-off sort of way, which is often the case with callbacks like this.

One could just as easily done this:

````cfc
function mapper(element){
	// do stuff to the element
	// return updated element
}

newArray = array.map(mapper);
````

Of course `mapper` might not even be a stand-alone function, it might be a method of a class:

````cfc
myObject = new SomeClass(); // SomeClass has a `mapper()` method

newArray = array.map(myObject.mapper);
````

Functions themselves will be covered in a later chapter. And a discussion on closure and its uses also a chapter of its own. They're both big topics.


#### XML ####

CFML has a specific data type for XML. XML has fallen out of favour a bit in the last couple of years in favour of schemes like JSON, so I'll only touch on XML here.

````cfc
x = xmlParse('
	<aaa>
		<bbb ccc="ddd">eee</bbb>
		<fff ggg="hhh">iii</fff>
	</aaa>
');
fffTagText = x.search("/aaa/fff/text()")[1].xmlValue; // iii
````

Here we take a string and parse it into XML using the function `xmlParse()`, and then we can call the `search()` method on that to perform an XPath search on it.

Unfortunately CFML's XML support for adding to existing XML objects is a bit clumsy:

````cfc
x.aaa[1].XmlChildren.append(x.elemNew("jjj")); 
````

This appends an empty `<jjj/>` element after the `<fff/>` one, within `<aaa/>`, eg:

````xml
<aaa>
	<bbb ccc="ddd">eee</bbb>
	<fff ggg="hhh">iii</fff>
	<jjj/>
</aaa>
````

As alluded to in the code here, XML objects can be accessed with a kinda of array notation. Here are some examples:

````cfc
x = xmlParse('
<aaa>
	<bbb ccc="ddd">eee</bbb>
	<fff>
		<ggg>hhh</ggg>
	</fff>
	<bbb>iii</bbb>
</aaa>
');
x.aaa.bbb; // the first bbb element
x.aaa.bbb[1]; // also the first bbb element
x.aaa.bbb[2]; // the second bbb element

x.aaa.xmlChildren; // bbb,fff,bbb elements as an array
x.aaa.xmlChildren[1]; // the first bbb element
x.aaa.xmlChildren[2]; // the fff element

x.aaa.fff.ggg.xmlattributes; // both the hhh and jjj attributes/values as a struct
x.aaa.fff.ggg.xmlattributes.hhh; // iii
x.aaa.fff.ggg; // the ggg node
x.aaa.fff.ggg.xmltext; // lll
````

There's not much more to XML obejct manipulation beyond that.

[cover XSLT briely? Does anyone care these day?]


#### Other ####

There are other inbuilt data types which I won't cover here:

* image
* spreadsheet
* ftp
* file

They are either not really core to CFML (image and spreadsheet), or never really *used* as data types (the latter two). There's not really much to say about them that the documentation doesn't cover.
