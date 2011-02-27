package  
{
	import spark.components.Group;
	import mx.controls.Alert;
	import mx.managers.ToolTipManager;
	
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
		private var isSearch : Boolean;
		
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
			
			this.hide();
			
			trace("Graph created");
		}
		
		/**
		 * Draw the graph in the current environment.
		 */
		public function draw() : void
		{
			trace("draw");
			DrawGraph.DrawG(this.data, this, this.center);
			
			show();
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
			
			Network.graphGet(id, this.loadGraph, this.reportError);
		}
		
		/**
		 * Hide the graph.
		 */
		public function hide() : void
		{
			trace("Graph.hide()");
			
			this.visible = false;
			this.graph.visible = false;
			this.isSearch = false;
		}
		
		/**
		 * Return whether or not the graph is visible.
		 */
		public function isVisible() : Boolean
		{
			return this.visible;
		}
		
		/**
		 * Receive the callback data from graph xml request.
		 * 
		 * @param	data
		 */
		public function loadGraph(data : XML) : void 
		{
			trace("Graph.loadGraph");
			
			this.data = Parse.parseGraph(data);
			this.center = new Node(this, 0, 0);
			
			this.center.id = this.data[0][0];
			this.center.title = this.data[0][1];
			this.center.label = this.data[0][1];
			
			this.draw();
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
		public function resize() : void
		{
			trace("Graph.resize");
			
			this.graph.width = this.environment.width;
			this.graph.height = this.environment.height;
			
			if (this.isVisible() && !this.isSearch) 
			{
				this.draw();
			}
			else if (this.isVisible() && this.isSearch)
			{
				this.drawSearch();
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
		 * Return the width of the graph.
		 * 
		 * @return
		 */
		public function width() : Number
		{
			return this.graph.width;
		}
		
		/*****************************************************************************************/
		
		/**
		 * Draws the results of a search in a table format. It will draw six wide and four tall.
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
		public function drawSearch() : void
		{
			this.clearGraph();
			
			var max:int = (this.data.length > 24) ? 24 : this.data.length;
			
			var searchChrome:int = 25;
			
			var cols:int = 6;
			
			var rows:int = max / cols;
			var lastRow:int = max % cols;
			
			var offsetX:int = 10;
			var offsetY:int = 10;
			
			var width:int = (this.graph.width - ((cols + 1) * offsetX)) / (cols);
			var height:int = (this.graph.height - searchChrome - ((rows + 1) * offsetY)) / (rows);
			
			// Loop through by rows
			for (var i:int = 0; i < rows; i++)
			{
				
				var y:int = ((i + 1) * offsetY) + (i * height) + searchChrome;
					
				// Loop through by each cell in a row.
				for (var j:int = 0; j < cols; j++)
				{
					var x:int = ((j + 1) * offsetX) + (j * width);
					var index:int = (i * cols) + j;
					
					drawNode(index, this.data[index][0], this.data[index][1], x, y, width, height);
				}
				
			}
			
			// draw last row
			
			var lastY:int = ((rows + 1) * offsetY) + (rows * height) + searchChrome;
			for (var lastJ:int = 0; lastJ < lastRow; lastJ++)
			{
				var lastX:int = ((lastJ + 1) * offsetX) + (lastJ * width);
				var lastI:int = (rows * cols) + lastJ;
				
				drawNode(index, this.data[lastI][0], this.data[lastI][1], lastX, lastY, width, height);
			}
		}
		
		/**
		 * Clear the current graph environment.
		 */
		public function clearGraph() : void
		{
			trace("Graph.clearGraph()");
			
			ToolTipManager.enabled = false;
			this.graph.removeAllElements(); //clear the previous graph
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
			newNode.label = title;
			
			newNode.x = x;
			newNode.y = y;
			
			newNode.width = width;
			newNode.height = height;
			
			newNode.alpha = 1;
			
			this.graph.addElement(newNode);
		}
		
		/*************************************************************************************************/
	}

}