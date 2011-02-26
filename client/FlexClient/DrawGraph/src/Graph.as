package  
{
	import spark.components.Group;
	import mx.controls.Alert;
	
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
			
			if (this.isVisible()) 
			{
				this.draw();
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
		
	}

}