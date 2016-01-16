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

As mentioned above, scopes are objects into which variables go. There are several scopes that the CFML server maintains, and all variables go into one or other of these scopes. Each scope has two significant characteristics:


### Access/availability ###

Most scopes are available to all code. That said one should exercise good judgement and sound architectural practices in one's code, so whilst server-wide variables might be available to the code within a method within a class, this does not mean one should access it directly just because one can. One should encapsulate and decouple code and practise information hiding as much as possible in one's code.

Code is executed in a context, and that context might be contained within other contexts. For example all code runs in the context of a JVM; within that a given CFML application also has its own context, and within that a visitor to the application (ie: browsing to the web site) can have their own session which sticks with them for the duration of their visit. From a code-centric point of view, a component's code is run in a separate memory space (so: context) from the code that calls the component's code; and functions being executed likewise have their own context to store variables in which is separate again from the component itself, and the calling code.

A couple of scopes have localised context, and variables within them are only accessible within that context. For example the context of the `local` scope within a function is only accessible to the code within that calling instance of that specific function. Other functions called within the first function have a separate local scope. And calling code has no access to a function's local scope.


### Lifetime ###

Some scopes have very long lifetime some are very short.


## List of Scopes ##

Notes: This section could be done in either topical order or alphabetical order or most used to least used. It is not good to start this topic with Server scope as it is the most rare, but it does make sense when going from widest to narrowest scope. Holding off on details until there is consensus on format and order


###Server###
**Description:** There are variable that exist across all applications on a server. Any change done to these variables will be seen on all request for all users on all applications.

**Usage:** ColdFusion exposes some of its internal variables here.

**Notes:** This scope should be avoided because it has such a wide impact. It may lead to performance issues. 

**Example:**


###Application###
**Description:** This variables exist for an entire application. These are setup in `application.cfc` in the `onApplicationStart()` function

**Usage:**

**Notes:**

**Example:**



###Session###
**Description:** These are initially setup in `application.cfc`, but can be used and modified anywhere  in the `onSessionStart()` function

**Usage:**

**Notes:** Session management must be turned on to use these

**Example:**




###Request###
**Description:**

**Usage:**

**Notes:**

**Example:**



###Variables (outside of CFC)###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Form###
**Description:** Variables that were submitted on a POST (`<form method="post">`) operation

**Usage:**

**Notes:**

**Example:**




###URL###
**Description:**  Variables that were submitted on a GET (`<form method="get">` or `<a href="mypage.cfm?ID=">`) operation

**Usage:**

**Notes:**

**Example:**




###CGI###
**Description:** This are variables associated with the request from the web server's point of view.

**Usage:**

**Notes:**

**Example:**




###Cookie###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Client###
**Description:**

**Usage:**

**Notes:**

**Example:**




Notes: CFC scopes


###This###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Variables (inside of a CFC)###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Local###
**Description:**

**Usage:**

**Notes:**

**Example:**




###var (Keyword)###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Arguments###
**Description:**
**Usage:**
**Notes:**
**Example:**


###Super###
**Description:**

**Usage:**

**Notes:**

**Example:**





###Un scoped###
**Description:**

**Usage:**

**Notes:**

**Example:**




Notes: Custom tag scopes

###ThisTag###
**Description:**

**Usage:**

**Notes:**

**Example:**




###Attributes###
**Description:**

**Usage:**

**Notes:**

**Example:**



###Caller###
**Description:**

**Usage:**

**Notes:**

**Example:**



Notes: Error handling

###Cfcatch###
**Description:**

**Usage:**

**Notes:**  There is also a tag called cfcatch

**Example:**






Notes: And then threads, closures, cfhttp, cfftp, and other






