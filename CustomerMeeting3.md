# Customer Meeting #3 #

**Thursday, January 27, 2011**

This meeting was used to review our SRS. Generally they seemed pleased with everything mentioned in the requirement, including .

## Notes ##

  * The swith on the frontend client from js to flash was mentioned. The customers were cautionary about the potential challenges of building a flash app, but were fine with the decision.
  * The customers asked the following questions about our UI prototypes (our answers included):
    1. **What does clicking a node in the graph do?** A:
      * Clicking a non central node brings the node to the center and redraws the map (in one way or another yet undetermined).
      * Hovering on a node shows a tooltip with abstract and buttons to open full article on wikipedia in a new tab/window.
      * Double clicking opens the article on wikipedia in a new tab/window
    1. **Will panning & zooming be a feature?** A: No, it is a stretch feature, which depends on the facility to render multiple degrees of connection.
    1. **How large is the database going to be?** A: On the scale of 100GiB.
    1. **What is going to happen with the database, given its large size?** A: We are looking into hosting it on Amazon Web Services. Cubist will not suffice. If all else fails, a small database will be hosted on Cubist.
    1. **How consistent will our maps be with wikipedia?** A: The database dumps are produced monthly. We probably should put a disclaimer about this on the site somewhere...
    1. **How portable will the product be? Could it be connected to another Wiki-like site (CS wiki, for example)?** A: We intend to design and produce a product that can easily work with a database with the same schema. This includes the set of all databases which are based on the Wikimedia organization's wiki site format. Basically any site that follows the wikipedia design should be able add this product with little or no friction.