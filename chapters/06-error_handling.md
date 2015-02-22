# Error handling #

I touched on exception handling before, but only in the context of how exception handling impacts flow control, rather than really going through the concepts behind it.

Code will error. That's the first thing to accept... there's no such thing as bug free code (one can come up with trite examples to the contrary, but you know what I mean), and we just need to deal with bugs as they occur. But also sometimes is a fairly "logically sound" piece of code, things still go wrong, and whilst in some situations it's not reasonable to expect a problem so no reason to really try to code defensively around it, there are other situations in which it's more easy to predict that something will go wrong. These situations generally revolve around interactions with external systems rather than your own code. External systems are things like remote web services, third-party APIs, the local file system and... humans. These things all conspire to make our code break. Our code should deal with predictable systems by coding so that errors are not likely to occur - and errors that do occur are probably bugs - however when dealing with external systems one should only code an application to "work" for predictable inputs and outputs, and when unpredictable events happen - exception circumstances - the best way to handle it is to expect it to break, and pick up the pieces carefully once it's done so. This is exception handling.

Another completely legitimate scenario is to handle an occurrence from some external system (say: user input), expect it to be unreliable, intercept an error situation and as part of dealing with that situation either allow the error to bubble back to the user, or bubble a different error to the user.

I'm a big believer in "garbage in / garbage out": if my code receives duff inputs or other behaviour from an external system, don't try to work out what might have been meant, just throw an error back.

But before getting too entrenched in "what to do", let's look at how to do it.

We might have some code:

````cfc
result = runSomeProcessThatReliesOnAnExternalSystem();
````

We should always code defensively, which means the only code that we can trust is code that we wrote: our own application, basically. Defensive coding suggests that that line of code could error. If we let it error, then it's our fault. It we deal with it erroring, we've done out best, which is good enough.

Normally if the CFML server encounters something it doesn't like, it'll just error. If it's a runtime error, this means it will raise an exception, and halt. And all things being equal, you'll get an error on the screen.

However because it raises an exception before it halts, this gives our application code a chance to deal with the exception. We can catch it, inspect it, and decide what best to do with it. To catch an exception, we need to tell CFML we're on the look-up for exceptions to catch. We do this by "trying" to run some code:

````cfc
try {
    result = someExternalSystem.runSomeProcess();
}
````

This is syntactically incomplete, because as well as *trying* the code, we need to tell CFML what we're going to do with it once we've tried it. There are a couple of options, but we're just looking at catching whatever exception has been thrown first:

````cfc
catch (any e) {
    // do something here
}
````

To be clear, that's not syntactically complete either. We need to stick 'em together:

````cfc
try {
    result = someExternalSystem.runSomeProcess();
} catch (any e) {
    // do something here
}
````

I separated it out merely to get you to think about what's going on: we `try` some code; we `catch` any exception that tried code might throw.

## Digression: types of errors ##

I've perhaps not been as careful as I should be with my terminology here, but this is reflective of common usage. I will use the notion of "error" and "exception" interchangeably. This is unhelpfully vague. Errors come in various flavours, and not all of them result in exceptions. In CFML there are really only two types of errors to worry about: compile-time errors, and run-time errors.

Because there's no discrete compilation step in producing a CFML application, people often don't realise that CFML code is indeed compiled before it is executed. When you write code, it's not that actual code that runs. The CFML compiler compiles it to JVM-ready byte-code, and it's *this* that is executed. CFML uses a notion of "Just In Time" compiling. As a file is needed by your application, it's compiled. This is discussed more in depth in [Request/response process & scopes](chapters/09-request_response.md).

This is relevant in the context of errors because if code is not syntactically valid, then it can't compile, so CFML will throw an error. Here's an example:

````cfc
result = someFunction(;
````

Note that that code is malformed: it doesn't have its closing parenthesis. Syntax errors like this prevent the file from compiling, and yield a compile error:

<table border="1">
<tbody>
<tr><td colspan="2">Lucee 4.5.1.003 Error (template)</td></tr>
<tr><td>Message</td><td>Syntax Error, Invalid Construct</td></tr>
<tr>
<td>Stacktrace</td>
<td>
The Error Occurred in<br>
C:\code\6\compileError.cfm: line 2<br> 
<pre><code>1: &lt;cfscript&gt;
2: result = someFunction(;
3: &lt;/cfscript&gt;
</code></pre>
</td>
</tr>
<tr>
<td>Java Stacktrace</td>
<td>
Syntax Error, Invalid Construct<br>
<pre>    at lucee.transformer.cfml.expression.AbstrCFMLExprTransformer.checker(Unknown Source):-1 <br>
    etc
</pre>
</td>
</tr>
</tbody>
</table>


This is not *particularly* clear that there's been a compile error, but if you see "syntax error", then it's a compile error.

Why is this important? Because compile errors occur *before the code can be run*. And to handle errors - to catch exceptions - we need to use code (ie: `try` / `catch`). And for code to be read, it needs to be run... and for it to run, it needs to be compiled first.

The ramification is that one can only use CFML's error handling to deal with *runtime* errors. It cannot deal with compilation errors.

We can't do this:

````cfc
try {
result = someFunction(;
} catch (any e){
	// deal with that syntax error
}
````
The only errors we can deal with are runtime errors: errors that crop up as part of the code running. This is a runtime error:

````cfc
result = 1 / 0;
````

`1 / 0` is not a valid expression bececause one cannot divide by zero: it's a mathematical impossibility. The CFML runtime will detect this, error, and as part of the error occurring, it will raise an exception. So we can `catch` that:

````cfc
try {
	result = 1 / 0;
} catch (any e){
	writeOutput("type: #e.type#; message: #e.message#");
}
````

This will result in this output:

````cfc
type: java.lang.ArithmeticException; message: Division by zero is not possible
````

Oh, let's look at it *without* the `try` / `catch`:

<table border="1">
<tbody>
<tr><td colspan="2">Lucee 4.5.1.003 Error (java.lang.ArithmeticException)</td></tr>
<tr><td>Message</td><td>Division by zero is not possible</td></tr>
<tr>
<td>Stacktrace</td>
<td>
The Error Occurred in<br>
C:\code\6\divisionByZero.cfm: line 2<br> 
<pre><code>1: &lt;cfscript&gt;
2: result = 1 / 0;
3: &lt;/cfscript&gt;
</code></pre>
</td>
</tr>
<tr>
<td>Java Stacktrace</td>
<td>
Division by zero is not possible<br>
<pre>    at lucee.runtime.op.Operator.divRef(Unknown Source):-1<br>
    etc
</pre>
</td>
</tr>
</tbody>
</table>

So using `try`/`catch` the error still occurs, but instead of exiting, we are able to catch the exception, then do something. In my example I'm just outputing some info about the exception, but one can do whatever one wants there to deal with the situation as appropriate.

It's worth reviewing the `try`/`catch` section in the  [Control structures](02-flow_control.md#try-catch) chapter to understand the flow control of a the `try`/`catch` process, but basically it's

````cfc
// 1. this runs
try {
	// 2. this runs
	// 3. this errors
	// -. this does not run
} catch (any e){
	// 4. processing jumps to here
	// 5. etc
}
// 6. then continues on from here

````

So it's important to note that when one handles an error, then processing *doesn't* halt like it does when an unhandled error is encountered. So if one wants to handle some error condition, but then still halt processing: one actually needs to code for that. There are a few options here:

* rethrow the original exception - this will cause the same error condition again, and processing will stop with that error
* throw a *different* exception - this again will cause an error, but bubble up a different exception to code possibly handling it or listening for it.
* simply abort processing.

Here's an example:

````cfc
try {
	result = someExternalSystem.runSomeProcess();
} catch (any e){
	someExternalSystem.closeConnection();
	logger.logError("#e.type# #e.message# occurred when calling runSomeProcess()");
	abort;
}
````

This speculative example shows running some tidy-up code when the error occurs, then logging that it happened, but then simply aborting processing. `abort` simply says to the CFML engine "that's the end of that".

Instead of the `abort`, we could use `rethrow` to cause the same error to be repeated. Going back to our earlier example:

````cfc
try {
	result = 1 / 0;
} catch (any e){
	writeOutput("type: #e.type#; message: #e.message#");
	rethrow;
}
````

Now we get:

<code>
type: java.lang.ArithmeticException; message: Division by zero is not possible
</code>
<table border="1">
<tbody>
<tr><td colspan="2">Lucee 4.5.1.003 Error (java.lang.ArithmeticException)</td></tr>
<tr><td>Message</td><td>Division by zero is not possible</td></tr>
<tr>
<td>Stacktrace</td>
<td>
The Error Occurred in<br>
C:\code\6\divisionByZero.cfm: line 2<br> 
<pre><code>1: &lt;cfscript&gt;
2: result = 1 / 0;
3: &lt;/cfscript&gt;
</code></pre>
</td>
</tr>
<tr>
<td>Java Stacktrace</td>
<td>
Division by zero is not possible<br>
<pre>    at lucee.runtime.op.Operator.divRef(Unknown Source):-1<br>
    etc
</pre>
</td>
</tr>
</tbody>
</table>

So we get both the error handling code running, but then we just get the original error again.

Or, similarly, we can cause a new error to occur, by throwing our own exception:

````cfc
try {
	result = 1 / 0;
} catch (any e){
	writeOutput("type: #e.type#; message: #e.message#");
	throw(type="BadExpressionException", message="The provided expression was invalid", detail="Original exception: #e.type#");
}
````

<code>
type: java.lang.ArithmeticException; message: Division by zero is not possible
</code>
<table border="1">
<tbody>
<tr><td colspan="2">Lucee 4.5.1.003 Error (BadExpressionException)</td></tr>
<tr><td>Message</td><td>The provided expression was invalid</td></tr>
<tr><td>Description</td><td>Original exception: java.lang.ArithmeticException</td></tr>
<tr>
<td>Stacktrace</td>
<td>
The Error Occurred in<br>
C:\code\6\divisionByZero.cfm: line 6<br> 
<pre><code>4: } catch (any e){
5: writeOutput("type: #e.type#; message: #e.message#");
6: throw(type="BadExpressionException", message="The provided expression was invalid", detail="Original exception: #e.type#");
7: }
8: </cfscript>
</code></pre>
</td>
</tr>
<tr>
<td>Java Stacktrace</td>
<td>
The provided expression was invalid<br>
<pre>    at shared.cfml24h.code._6.divisionbyzero_cfm$cf.call(C:\code\6\divisionByZero.cfm:6):6<br>
    etc
</pre>
</td>
</tr>
</tbody>
</table>

TBC

