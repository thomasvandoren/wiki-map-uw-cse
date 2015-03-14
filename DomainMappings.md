# Domain Mapping on Cubist #

http://wikigraph.cs.washington.edu/ is our main url. The table below shows the alias mapping (i.e. where code needs to be deployed in order to work).

## General Endpoints ##

| **URL path** | **Cubist Alias** | **Description** |
|:-------------|:-----------------|:----------------|
| [/](http://wikigraph.cs.washington.edu/) | WikiMap-M/proj/redir/ | Redirects to frontend client |
| [/graph](http://wikigraph.cs.washington.edu/graph) | WikiMap-M/proj/graph | Frontend Flash client |
| [/api](http://wikigraph.cs.washington.edu/api) | WikiMap-M/proj/api | Services |
| [/test](http://wikigraph.cs.washington.edu/test) | WikiMap-M/proj/test | Endpoint for testing frontend in a production-like environment |
| [/test-api](http://wikigraph.cs.washington.edu/test-api) | WikiMap-M/proj/test-api | Endpoint for testing services in a production-like environment |
| [/reviews/](http://wikigraph.cs.washington.edu/reviews/) | WikiMap-M/proj/review. | ReviewBoard |
| [/build](http://wikigraph.cs.washington.edu/build) | Redirects... | Hudson CI build service |

## API Endpoints ##

See [XMLDataSpecification](XMLDataSpecification.md) for the response structures these endpoints return.

| **URL path** | **Cubist Path** | **Description** |
|:-------------|:----------------|:----------------|
| [api/graph/(id)/](http://wikigraph.cs.washington.edu/api/graph/18843/) | graph.php?id=(id) | Returns the graph for the given id. |
| [api/abstract/(id)/](http://wikigraph.cs.washington.edu/api/abstract/18843/) | abstract.php?id=(id) | Returns the abstract for the article with the given id. |
| [api/search/?q=(query)](http://wikigraph.cs.washington.edu/api/search/?q=Ruby) | search.php?q=(query) | Returns the search results for the given query. |
| [api/autocomplete/?q=(query)](http://wikigraph.cs.washington.edu/api/autocomplete/?q=Ruby) | autocomplete.php?q=(query) | Returns the top 10 results for autocomplete. |
| [api/link/?q=(query)](http://wikigraph.cs.washington.edu/api/link/?q=Ruby) | link.php?q=(query) | Redirects to the wiki page for the given query. |

The test api endpoints are also active.

| **URL path** | **Cubist Path** | **Description** |
|:-------------|:----------------|:----------------|
| [test-api/graph/(id)/](http://wikigraph.cs.washington.edu/test-api/graph/18843/) | graph.php?id=(id) | Returns the graph for the given id. |
| [test-api/abstract/(id)/](http://wikigraph.cs.washington.edu/test-api/abstract/18843/) | abstract.php?id=(id) | Returns the abstract for the article with the given id. |
| [test-api/search/?q=(query)](http://wikigraph.cs.washington.edu/test-api/search/?q=Ruby) | search.php?q=(query) | Returns the search results for the given query. |
| [test-api/autocomplete/?q=(query)](http://wikigraph.cs.washington.edu/test-api/autocomplete/?q=Ruby) | autocomplete.php?q=(query) | Returns the top 10 results for autocomplete. |
| [test-api/link/?q=(query)](http://wikigraph.cs.washington.edu/test-api/link/?q=Ruby) | link.php?q=(query) | Redirects to the wiki page for the given query. |