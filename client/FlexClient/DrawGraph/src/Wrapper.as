package  
{
	/**
	 * This class is used to call the HTML/JS wrapper and to
	 * setup calls from the wrapper to functions in this
	 * Flex application.
	 * 
	 * @author Thomas Van Doren
	 */
	public class Wrapper 
	{
		import flash.external.ExternalInterface;
		
		public function Wrapper(graphLoad : Function)
		{
			if (ExternalInterface.available)
			{
				// Allow javascript wrapper to call loadGraph function.
				ExternalInterface.addCallback("loadGraph", graphLoad);
			}
		}
		
		/**
		 * Call the wrapper function getGraphId to retrieve the
		 * graph id from the hash tag. this does not actually return
		 * anything, but it tells the browser to call loadGraph.
		 */
		public function getGraph() : void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("getGraphId");
			}
		}
		
		/**
		 * Set the browser hash tag by calling the js function with
		 * the given id.
		 * 
		 * @param	id
		 */
		public function setGraph(id : String) : void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("setHashTag", id);
			}
		}
		
	}

}