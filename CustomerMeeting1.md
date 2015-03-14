# Customer Meeting #1 #

**Thursday, January 13, 2011**

This meeting was used to discuss minimum requirements, potential risks, and general expectations. The product was the main focus. No details about implementation were specified.

## Commitments ##

Our group has committed to the following items.

  * A Google Maps-like web interface
    * A search bar at the top
    * Results (listings and graphs) below
  * Search
    * Searching for a phrase will most often result in an exact result (user is always 'feeling lucky')
    * When uncertain (not defined) a listing of 'Disambiguations' is shown
      * It has not been specified where the disambiguations come from. Presumably it will be a relevance sorted list of articles 'LIKE' the search query.
      * When to fall into the list of disambiguations was also not defined. A confidence threshold will have to be defined for approximating user input when it does not exactly match.
      * Zero seems like a reasonable starting threshold. Any query that does not exactly match an article will require the user to select the article from the disambiguation list.
    * Further design and implementation specifications of the search have been left undefined, for now.
  * The Graph
    * The search query will designate a central node.
    * At a minimum all articles linked to by the central node (central node -> other articles) will be displayed.
    * Special content page nodes (disambiguation pages were the only ones mentioned) will be colored differently than normal article nodes
    * Each node will, at a minimum, provide a tool tip with its title and a short abstract.
    * The specific look and feel of the graph (where nodes are placed, how they are drawn, etc) has been left undefined for now. A systematic arrangement based on relevance is required.
  * Other Information
    * A real progress bar is required to be shown during all background processing. With an accurate progress bar, response times are not limited (except by the user's patience).
    * The rendering performance of the first degree of connections should not be affected by the rendering of greater degrees
      * Progress bar will track loading of other degrees in the background.
      * The graph will be rendered from the center out.

## At Risk Items ##

These items are viewed as highly desirable, but should only receive resources once the above items are under control. We are not committed to any of the following items.

  * Show 'in bound' connections to articles.
    * This would render articles that link to the central node.
    * Presumably, this would expand to the same number of degrees as the 'out bound' connections
  * Rendering more than one degree (two options)
    1. Requiring user to initiate the request for and rendering of each additional degree, or specifying a specific number of degrees to render
    1. Request first degee, start rendering and asynchronously request the second degree, ... start rendering nth degree and asynch request (n+1)th degree.
  * Graph UI Ideas
    * Abililty to zoom and pan around the graph
    * Assumption: graph would update based on user visibility (i.e. start with central node, but move based on current center?)
    * Create various node sizes based on relevance (more links in/out/both?); more relevant, more visible; zoom in for more granularity
    * This item seems to depend on having multiple degree displayed

## Wish List Items ##

These items will be allocated resources when all above items are on or ahead of schedule and additional resources exist.

  * Search for two central nodes. Display the intersection of their connections.
    * This could be a really cool feature.
    * Idea: the second central node could be selected after the query
    * Idea: all the intersecting connections between two nodes, to an nth degree, would be highlighted; other connections still displayed
  * Some parts of the 'At Risk Items' more accurately fall under this category, but for the sake of relevance, were left above.