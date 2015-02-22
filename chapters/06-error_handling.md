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
    result = runSomeProcessThatReliesOnAnExternalSystem();
}
````

This is syntactically incomplete, because as well as *trying* the code, we need to tell CFML what we're going to do with it once we've tried it. There are a couple of options, but we're just looking at catching whatever exception has been thrown first:

````cfc
catch (any e) {
    // do something here
}
````




