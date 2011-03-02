package  
{
	import flash.events.Event;
	import flash.text.TextFormat;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import Graph;
	import spark.components.Group;
	
	/**
	 * This class contains and updates a list of the top 10 most recent search results
	 * 
	 * @author Michael Rush
	 */
	public class History 
	{
		private var searchTerms : Array;
		private var searchIDs : Array;
		private var size : int;
		private var list : ComboBox;
		private var graph : Graph;
		
		/**
		 * Construct a new graph that knows about the graph and its environment.
		 * Set the graph to be located to the left of the autocomplete bar
		 * 
		 * @param	g
		 * @param	environment
		 */
		public function History(g : Graph, environment : Group) 
		{
			graph = g;
			searchTerms = new Array();
			searchIDs = new Array();
			size = 0;
			
			list = new ComboBox();
			list.width = 150;
			list.x = 105;
			list.y = 8;
			list.dataProvider = searchTerms;
			list.text = "Search History...";
			list.addEventListener("change", doSearch);

			environment.addElement(list);
		}
		
		/**
		 * Add a new (term, id) pair to the search records. Only the 10 most recently searched terms will be stored.
		 * 
		 * @param	term
		 * @param	id
		 */
		public function addRecord(term : String, id : String): void {
			if (size >= 10) {
				searchTerms.pop();
				searchIDs.pop();
				size--;
			}
			firstOne = term;
			searchTerms.unshift(term);
			searchIDs.unshift(id);
			size++;
		}
		
		private var firstOne:String;
		
		/**
		 * 
		 * @return the current center node title
		 */
		public function getCurrentTitle():String {
			return firstOne;
		}
		
		/**
		 * Remove the (term, id) pair located at the given index.
		 * 
		 * @param	i
		 */
		public function removeRecord(i : int): void {
			if (size > 0) {
				searchTerms.splice(i,1);
				searchIDs.splice(i, 1);
				size--;
			}
		}
		
		/**
		 * Perform a search on the clicked term. Move the clicked term to the top of the search history results
		 * 
		 * @param	event
		 */
		private function doSearch(event : Event) : void {
			var search : String = searchIDs[list.selectedIndex] as String;
			// Runs removeRecord if the selected title is not the current
			if(list.selectedIndex!=0){
				removeRecord(int(list.selectedIndex));
			}
			graph.getGraph(search);
			list.text = "Search History...";
			list.selectedItem = null;
		}
	}

}