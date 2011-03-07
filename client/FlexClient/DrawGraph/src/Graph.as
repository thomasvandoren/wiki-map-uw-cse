package  
{
	import mx.managers.HistoryManager;
	import spark.components.Group;
	import mx.controls.Alert;
	import mx.managers.ToolTipManager;
	import GIFPlayerComponent;
	import EmbedAssets;
	import mx.core.ByteArrayAsset;
	
	/**
	 * This class represents the graph state and behavior.
	 * 
	 * @author Thomas Van Doren
	 */
	public class Graph 
	{
		
		
		private var graph : Group;
		private var environment : Main;
		private var data : Array;
		private var center : Node;
		private var visible : Boolean;
		public var isSearch : Boolean;
		private var wrapper : Wrapper;
		private var history: History;
		private var loaderImg : GIFPlayerComponent;
		private var loaderImgSrc : ByteArrayAsset = new EmbedAssets.LOADING_SMALL();
		private var loading : Boolean;
		
		/**
		 * Construct a new graph that knows about it environment.
		 * The graph is initially hidden.
		 * 
		 * @param	graph
		 * @param	environment
		 */
		public function Graph(graph : Group, environment : Main) 
		{
			this.graph = graph;
			this.environment = environment;
			this.history = new History(this, environment.history);
			
			this.wrapper = new Wrapper(this.loadGraphById);
			
			this.createLoaderImg();
			
			this.hide(false);
			
			trace("Graph created");
		}
		
		/**
		 * Clear the current graph environment.
		 */
		public function clearGraph() : void
		{
			trace("Graph.clearGraph()");
			
			ToolTipManager.enabled = false;
			this.graph.removeAllElements(); //clear the previous graph
			this.wrapper.clearGraph();
		}
		
		/**
		 * Draw the graph in the current environment.
		 */
		public function draw(showAnim : Boolean = true) : void
		{
			trace("draw");
			
			this.visible = true;
			this.isSearch = false;
			
			DrawGraph.DrawG(this.data, this, showAnim);
			
			show();
		}
		
		/**
		 * Draws a single node on the graph at the given location.
		 * 
		 * @param	id
		 * @param	title
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function drawNode(index:int, id:String, title:String, x:int, y:int, width:int, height:int) : void
		{
			trace("Graph.drawNode()");
			
			//TODO: make a more relevant node for search results...
			
			var newNode:Node = new Node(this, 0, new Number(index));
			
			newNode.id = id;
			
			newNode.title = "string";
			newNode.label.text = title;
			
			newNode.x = x;
			newNode.y = y;
			
			newNode.width = width;
			newNode.height = height;
			newNode.setStyle("cornerRadius", newNode.height/2); //used to style the node correctly
			newNode.label.width = newNode.width;
			newNode.label.height = newNode.height;
			newNode.label.y = newNode.height / 6;
			newNode.label.setStyle("fontSize", newNode.height / 3);
			
			newNode.alpha = 1;
			
			this.graph.addElement(newNode);
		}
		
		/**
		 * Draws the search results in a table format.
		 */
		public function drawSearch() : void
		{
			this.clearGraph();
			DrawGraph.clearData();
			
			var displayMax:int = 48;
			
			var searchChrome:int = 25;
			var topOffset:int = searchChrome;
			
			var cols:int = 6;
			
			var offsetX:int = 10;
			var offsetY:int = 10;
			var maxOffsetY:int = 25;
			
			// Height is same as graph node height.
			var height:int = this.graph.height / 24;
			var width:int = ((this.graph.width - offsetX) / cols) - offsetX;
			
			var rows:int = (this.graph.height - offsetY - topOffset) / (height + offsetY);
			
			var max:int = rows * cols;
			
			max = this.data.length > max ? max : this.data.length;
			max = max > displayMax ? displayMax : max;
			
			rows = max / cols;
			
			if (max % cols > 0)
			{
				rows += 1;
			}
			
			var clusterHeight:int = rows * (height + offsetY) + offsetY;
			
			// If the window is large enough, make the results a bit farther apart.
			if (clusterHeight < (this.graph.height - topOffset))
			{
				offsetY = (this.graph.height - topOffset - (rows * height)) / (rows + 1);
				offsetY = offsetY > maxOffsetY ? maxOffsetY : offsetY;
			}
			
			clusterHeight = rows * (height + offsetY) + offsetY;
			
			// If the window still has room, move the search results down a third.
			if (clusterHeight < (this.graph.height - topOffset))
			{
				topOffset = (this.graph.height - topOffset - clusterHeight) / 3 + searchChrome;
			}
			
			// Loop through by rows
			for (var i:int = 0; i < rows; i++)
			{
				
				var y:int = i * (height + offsetY) + topOffset + offsetY;
					
				// Loop through by each cell in a row.
				for (var j:int = 0; j < cols; j++)
				{
					var index:int = (i * cols) + j;
					
					if (this.data[index] == null || index >= max)
					{
						break;
					}
					
					var x:int = j * (width + offsetX) + offsetX;
					
					drawNode(index, this.data[index][0], this.data[index][1], x, y, width, height);
				}
				
			}
			
		}
		
		/**
		 * Request the graph given by the id and then
		 * draw it.
		 * 
		 * @param	id
		 */
		public function getGraph(id : String) : void
		{
			trace("getGraph(" + id + ")");
			this.startLoad();
			Network.graphGet(id, this.loadGraph, this.reportError, true);
		}
		
		/**
		 * Return the height of the graph.
		 * 
		 * @return
		 */
		public function height() : Number
		{
			return this.graph.height;
		}
		
		/**
		 * Hide the graph.
		 */
		public function hide(clearHash : Boolean = true) : void
		{
			trace("Graph.hide()");
			
			this.visible = false;
			this.graph.visible = false;
			this.isSearch = false;
			
			if (clearHash)
			{
				this.wrapper.clearGraph();
			}
		}
		
		/**
		 * Return whether or not the graph is visible.
		 */
		public function isVisible() : Boolean
		{
			return this.visible;
		}
		
		/**
		 * Load the graph from hash tag, if available.
		 */
		public function load() : void
		{
			this.wrapper.getGraph();
		}
		
		/**
		 * Receive the callback data from graph xml request.
		 * 
		 * @param	data
		 */
		public function loadGraph(data : XML) : void 
		{
			this.stopLoad();
			this.data = Parse.parseGraph(data);
			
			this.center = new Node(this, 0, 0);
			
			this.center.id = this.data[0][0];
			this.center.title = this.data[0][1];
			this.center.label.text = this.data[0][1];
			
			//TODO: does this need to be in a different place?
			this.wrapper.setGraph(this.data[0][0]);
			
			// Do not display graph if the center node was clicked.
			if (!this.isVisible() ||
				this.isSearch ||
				history.getCurrentTitle() != this.data[0][1]) 
			{
				trace("Graph.loadGraph");
				this.draw();
				
				//Add search term and id to search history
				this.history.addRecord(this.center.title, this.center.id);
			}
		}
		
		/**
		 * Loads the graph with the given id. This function is callable from
		 * the HTML/JS wrapper.
		 * 
		 * @param	id
		 */
		public function loadGraphById(id : String) : void
		{
			trace("Main.loadGraph(" + id + ")");
			
			//TODO: validate/sanitize the id
			this.getGraph(id);
		}
		
		/**
		 * Loads the results of a search into data,
		 * 
		 * @param	results
		 */
		public function loadSearch(results:Array) : void
		{
			trace("Graph.drawSearch()");
			
			if (results.length == 0)
			{
				Alert.show("Search found no results.");
			}
			else
			{
				this.visible = true;
				this.isSearch = true;
				this.data = results;
				
				this.drawSearch();
			}
		}
		
		/**
		 * Create the loading image and text and add it to the environment
		 */
		private function createLoaderImg() : void
		{
			this.loaderImg = new GIFPlayerComponent();
			this.loaderImg.byteArray = this.loaderImgSrc;
			environment.loading.visible = false;
			environment.loadingImg.addElement(this.loaderImg);
			environment.loadingText.text = "";
		}
		
		/**
		 * Updates and displays the loading visual
		 */
		private function startLoad() : void
		{
			environment.loadingText.text = "Loading...";
			environment.loading.visible = true;
		}
		
		/**
		 * Hides the loading visual
		 */
		private function stopLoad() : void
		{
			environment.loading.visible = false;
		}
		
		/**
		 * Report error to user if graph request failed.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			Alert.show("Could not contact WikiGraph server");
		}
		
		/**
		 * Resize the graph to fill the environment.
		 */
		public function resize(showAnim : Boolean = true) : void
		{
			trace("Graph.resize");
			
			this.graph.width = this.environment.width;
			this.graph.height = this.environment.height;
			
			if (this.isVisible() && !this.isSearch) 
			{
				this.draw(showAnim);
			}
			else if (this.isVisible() && this.isSearch)
			{
				this.drawSearch();
			}else{
				DrawSplash.resize(graph);
			}
		}
		
		/**
		 * Return the graph object. This method may become unnecessary over time.
		 * 
		 * @return
		 */
		public function returnGraph() : Group
		{
			return this.graph;
		}
		
		/**
		 * Display the graph.
		 */
		public function show() : void
		{
			trace("Graph.show");
			
			this.visible = true;
			this.graph.visible = true;
			this.stopLoad();
		}
		
		/**
		 * Return the width of the graph.
		 * 
		 * @return
		 */
		public function width() : Number
		{
			return this.graph.width;
		}
		
	}

}