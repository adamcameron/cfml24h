# The CFML application server, the request/response process & scopes #

This section covers - at a very "executive summary" level - how a CFML server "works", at least in the context of responding to page requests, anyhow.

It also describes the data flow of a request from the time it's made from the client, across the network, being processed by the server, returned to the client, rendered and being made ready for consumption. Basically what happens from when one browses to a a web page through until the web page is displayed and operational.

It also covers a (loosely) tangential concept: scopes. These are objects that have differing "lifetimes" in the context of a block of code, or a request, or a user's visit to a site etc. Scopes are what variables are stored in.


## The CFML application server ##

This is not going to go into too much detail of the inner workings of Java servlet containers or that sort of thing: it's just a superficial look at what the CFML server does.

The CFML server is a software application that runs within a JVM (Java Virtual Machine). The JVM basically executes programs written in Java byte code. Which programs it runs - in the case of CFML processing - is dictated by a servlet container (eg: Apache Tomcat) which is another JVM application which basically runs a bunch of threads which listen on TCP/IP ports for requests coming in from a web server (or any source, I guess; but in the context of CFML, it's a web server). The servlet container will be configured to check the pattern of the URL being requested (for example: its file extension is .cfm or .cfc), and pass processing the request off to a servlet. The CFML application is a servlet (well: it's more than one, but that's not important in this context). The CFML servlet then works out what CFML code - ie: your source code files - are needed to respond to the request, compiles (if necessary) and executes the code, and returns the resultant data to the servlet container. The servlet container then potentially does its own thing to finalise the response, then passes all of that back to the web server.

Each request that comes into the CFML servlet runs on a thread, and it in turn can fire off additional threads as needs must. Once the request is completed, the thread is released and it waits for another request. The number of threads available to service requests is finite, the number being part of the CFML server's config. If the CFML server is set to use 50 threads, and it's currently processing 50 requests, then the 51st request will need to wait until one of the other threads finishes with its request and becomes available.

The JVM itself runs continuously in the background, unlike some other language's mechanisms. For example with PHP, a new PHP process is run for every request, but it is shut down at the end of the request. JVMs execute code very quickly whilst they are running, but do take quite a while to initially start up (a number of seconds). Once it's running though, its resources are available for use by JVM applications until it's shut down. This becomes relevant when we come to discuss scopes, further down.



## The request/response process ##


## Scopes ##