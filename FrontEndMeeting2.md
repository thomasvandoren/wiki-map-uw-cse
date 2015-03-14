# Introduction #
On Monday, 1/31, the font-end members met and decided on a general architecture, schedule, and assignments for the remainder of the quarter.


# Architecture #
For alpha, our architecture is organized into four main components: Search, Network, Parse, and Draw. These components are responsible for the following:

## Search ##
The search component will display a search bar and button on the front page that will accept user input. The search button will have an onClick event that will send a network request containing the search term to the Network component. Additionally, we expect the search bar will have a keyboard event where a list of suggestions related to the current search term will be requested from the Network component. When the Network component replies with the list of suggestions, the search bar will display an auto-complete suggestion drop-down, unless another request has already been sent.

## Network ##
The network component will take search and suggestion requests from the Search component. Upon receiving these requests, it will send an HTTPRequest to the server (we will have to discuss with the back-end how these requests should be formatted, and if requests for auto-complete is feasible). Responses will be recieved as an XML object (we need to discuss with back-end the exact format). Upon receiving the response, search requests will be sent to the Parse module, and suggestion requests will be send back to the Search module.

## Parser ##
The Parser component takes a XML object from the Network component. Upon receiving the XML object, the Parser will extract information for each node, and construct a Node list. The list will be formatted as a list of {ID, title, type} pairs, where ID is a unique identifier for each node given by the back-end, the title is the article name, and the type defines if the page is a central of leaf node. The node list will be restricted to 25 entries (1 root 24 leafs), and any additional nodes will be stored in memory for use by the "More results..." option. The Node list will then be sent to the Draw component as a GoodResult or BadResult, depending on if any matches were found.

## Draw ##
The Draw component takes a Node list from the Parser as a good or bad result. If a bad result is received, then the search help page will be displayed. Otherwise, the Node List will be draw onto the front page, with locations calculated according to the number of nodes. The Draw component will also accept "More results..." requests, which will take the remaining nodes from memory and display them in the same fashion as a GoodRequest.

## Alpha Goals, Schedule, and Assignments ##
By February 5th, we expect to have a simple set of features that will allow us to contact the back-end, receive the XML object, and display the first set of nodes. We would like to complete this in time for the back-end to take a look and give any suggestions.

### By Alpa (Feb 5) ###
Draw the simple UI containing the search bar/button - Michael
Ping the server and recieve an XML object - Michael
Parse node list from XML - Khanh
Draw nodes for each node in the list - Austin

### By Beta (Feb 20) ###
Week 1:
Get XML specific to search term - Michael;
Be able to recenter the nodes - Austin

Week 2:
Get auto-complete working - Michael;
Draw tooltips with links to article - Austin;
Get the "More Result..." function to work - Khanh

### By Release ###
Week 1:
Animations - Khanh

Week 2:
Search history / caching to view previous searches - All;
Option page: 2 degree? Persistant nodes? Zoom? Colors? - All

# Notes #
We need to discuss with the back-end how the XML response is structured for good and bad results. Also, we need to discuss with the back-end how we are going to do auto-complete (are queries on each typed character feasible?). Also, we would like to send our current version to the back-end once a week for review and bug testing.