package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.controls.Alert;
	import mx.controls.Button;
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
		
		private var btn : Button;
		private var ac : CustomAutoComplete;
		private var graph : Group;
		
		/**
		 * Create a new search button.
		 * 
		 * @param   btn
		 * @param	ac
		 * @param	graph
		 */
		public function SearchButton(btn : Button, ac : CustomAutoComplete, graph : Group) 
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
			Network.searchGet(ac.getText(), reportSearchResult, reportError);
		}
		
		/**
		 * Receive the search result callback. Draw the search with results.
		 * 
		 * @param	data
		 */
		public function reportSearchResult(data : XML) : void
		{
			DrawGraph.DrawSearch(Parse.parseSearch(data), graph);
		}
		
		/**
		 * Report error while trying to receive search results.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			Alert.show("Could not access WikiGraph server.");
		}
		
		public function setX() : void
		{
			this.btn.x = this.graph.width - 103;
		}
	}

}