package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.controls.Alert;
	import mx.controls.Button;
	import spark.components.BorderContainer;
	import spark.components.Group;
	
	/**
	 * This class handles the behavior of the search button.
	 * 
	 * @author Thomas Van Doren
	 */
	public class SearchButton
	{
		
		import Network;
		import Parse;
		import DrawGraph;
		import Graph;
		
		private var btn : BorderContainer;
		private var ac : CustomAutoComplete;
		private var graph : Graph;
		
		/**
		 * Create a new search button.
		 * 
		 * @param   btn
		 * @param	ac
		 * @param	graph
		 */
		public function SearchButton(btn : BorderContainer, ac : CustomAutoComplete, graph : Graph) 
		{
			this.btn = btn;
			this.ac = ac;
			this.graph = graph;
			
			this.setX();
			
			this.btn.addEventListener(MouseEvent.CLICK, this.handleSearch);
		}
		
		/**
		 * Click event handler. Sends a search request.
		 * 
		 * @param	event
		 */
		public function handleSearch(event : Event) : void
		{
			this.ac.lock();
			Network.searchGet(ac.getText(), reportSearchResult, reportError);
		}
		
		/**
		 * Receive the search result callback. Draw the search with results.
		 * 
		 * @param	data
		 */
		public function reportSearchResult(data : XML) : void
		{
			//
			// If an exact match was found, a graph will be returned.
			//
			
			this.ac.unlock();
			
			if (data.name() == "graph")
			{
				graph.loadGraph(data);
			}
			else
			{
				graph.loadSearch(Parse.parseSearch(data));
			}
		}
		
		/**
		 * Report error while trying to receive search results.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			this.ac.unlock();
			
			Alert.show("Could not access WikiGraph server.");
		}
		
		public function setX() : void
		{
			this.btn.x = this.graph.width() - 102;
		}
	}

}