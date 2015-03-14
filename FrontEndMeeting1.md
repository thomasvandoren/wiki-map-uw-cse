# Notes #
  * We’ll be using MXML, which is like part html, part JavaScript.
  * Looked over a couple of the tutorials, tried out some of the code provided to see what happened.
  * From what we have so far, dynamic graph creation with the nodes as buttons should be possible, as well as the ability to implement our “more info on hover” feature.
  * removeChildAt(index) will make it possible to remove instances from the environment, so we won’t have to reload the page every time we make a search.
  * Not too sure how the drawing hierarchy works yet (we need to make sure that the buttons get drawn on top of the lines).
  * We don’t exactly know how we’re going to connect to the server yet, but judging from the samples we found it’s definitely doable.
  * A viable function for this could be HTTPService, which works with PHP, is able to specify URL and can both send and receive information.
    * It would be best to find something that makes HTTP request to a generic webservice, and then handles a HTTP Response <sup>Thomas Van Doren</sup>
    * Just by name, it sounds like HTTPService can do that. (Our requests will be limited to GETs)
  * Tried out using the sample code to connect to a sample server, it worked (though there’s a 2-3 second delay it seems).
  * Found some code that makes it easy to embed the program into an http file, so it “should” be easy enough.
  * <mx: Script> is used to write Action Script, which can dictate advanced behaviors for button clicks and whatnot.
  * Simple animation doesn't seem to hard, though we'll probably ignore that until after alpha.
  * For our purposes, Flex should be fine and work for the client side.
    * w00t! <sup>Thomas Van Doren</sup>

# Summary #

Flex will work, has all the capabilities we need. Front End will spend time learning enough flash to complete the client side. Will need to research network communication a bit more. Need to confirm how backend will send their information to us.

--><sup>Thomas Van Doren</sup> The backend team is pretty flexible on how responses to the client will be formatted. Since the frontend client does not seem to need any sort of graph formatted text (i.e. dot output), I propose JSON or XML. We can figure out exactly how the data gets organized (the specific data structures) later, but for now we should decide on one format. Is one or the other easier to parse and import with Flex?