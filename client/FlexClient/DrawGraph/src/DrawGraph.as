package  
{
		import flash.text.engine.GroupElement;
		import flash.text.TextField;
		import mx.containers.Canvas;
		import mx.controls.TextArea;
		import mx.core.Application;
		import mx.core.UIComponent;
		import mx.graphics.SolidColorStroke;
		import mx.graphics.Stroke;
		import spark.components.Group;
		import spark.primitives.Line;
		import mx.controls.Alert;
		import mx.managers.ToolTipManager;
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	//Draws our WikiGraph, needs an multi-d-array which contains ID's in the first column
	//(row?) and article names in the second.
	public class DrawGraph
	{
		import flash.display.Shape;
		import mx.core.Container;
		import mx.states.AddChild;
		import Node;
		
		//tells the program to draw a bunch of nodes in the drawing area
		//NOTE: DrawG now requires a center Node to be provided, as the returned
		//list of nodes does not necessarily have the article itself come first
		public static function DrawG(a:Array, environment:Group, cNode:Node):void {
			ToolTipManager.enabled = false;
			if (a.length > 0) {
				environment.removeAllElements(); //clear the previous graph
				
				//presently this is how we're calculating the node's postion
				var j:Number;
				if (a.length > 25 || a.length==1) {
					j = (2 * Math.PI) / 24;
				}else{
					j = (2 * Math.PI) / (a.length - 1);
				}
				
				var centerNode:Node = new Node(environment,j,0); //the center node is created first, since it always belongs in the middle
				centerNode.id = cNode.id;
				centerNode.label = cNode.label;
				centerNode.width = environment.width/6;
				centerNode.height = environment.height/13;
				centerNode.x = (environment.width / 2) - (centerNode.width / 2);
				centerNode.y = (environment.height / 2) - (centerNode.height / 2);
				centerNode.alpha = 1;
				centerNode.title = cNode.label;

				// draw lines and nodes
				for (var i:Number = 1; i < 25 && i < a.length; i++) {
					var lengthCheck:String = a[i][1];
					if (lengthCheck.length > 0) {
					var newNode:Node = new Node(environment,j,i);
					newNode.id = a[i][0];
					newNode.title = a[i][1];
					var title:String = new String(a[i][1]);
					newNode.label = title.split("_").join(" ");
					newNode.width = environment.width/8;
					newNode.height = environment.height/24;
					newNode.x = newNode.getX(0.40, newNode);
					newNode.y = newNode.getY(0.40, newNode);
					newNode.alpha = 1;
					
					var newLine:UIComponent = new UIComponent();
					//line color defined here
					newLine.graphics.lineStyle(3, 0x666666, 1);
					newLine.name = a[i][0] + "_line";
					newLine.graphics.moveTo((environment.width / 2), (environment.height / 2));
					newLine.graphics.lineTo(newNode.x+newNode.width/2, newNode.y+newNode.height/2);
					
					// add line and its button
					environment.addElement(newLine);
					environment.addElement(newNode);
					}
				}
				// add center node button
				environment.addElement(centerNode);
			}
			environment.visible = true;
		}
		
		/**
		 * Draws the results of a search in a table format. It will draw six wide and four tall.
		 * 
		 * @param	results
		 * @param	env
		 */
		public static function DrawSearch(results:Array, environment:Group) : void
		{
			if (results.length == 0)
			{
				Alert.show("Search found no results.");
			}
			else
			{
				clearGraph(environment);
				
				var max:int = (results.length > 24) ? 24 : results.length;
				
				var searchChrome:int = 25;
				
				var cols:int = 6;
				
				var rows:int = max / cols;
				var lastRow:int = max % cols;
				
				var offsetX:int = 10;
				var offsetY:int = 10;
				
				var width:int = (environment.width - ((cols + 1) * offsetX)) / (cols);
				var height:int = (environment.height - searchChrome - ((rows + 1) * offsetY)) / (rows);
				
				// Loop through by rows
				for (var i:int = 0; i < rows; i++)
				{
					
					var y:int = ((i + 1) * offsetY) + (i * height) + searchChrome;
						
					// Loop through by each cell in a row.
					for (var j:int = 0; j < cols; j++)
					{
						var x:int = ((j + 1) * offsetX) + (j * width);
						var index:int = (i * cols) + j;
						
						drawSearchNode(environment, index, results[index][0], results[index][1], x, y, width, height);
					}
					
				}
				
				var lastY:int = ((rows + 1) * offsetY) + (rows * height) + searchChrome;
				for (var lastJ:int = 0; lastJ < lastRow; lastJ++)
				{
					var lastX:int = ((lastJ + 1) * offsetX) + (lastJ * width);
					var lastI:int = (rows * cols) + lastJ;
					
					drawSearchNode(environment, index, results[lastI][0], results[lastI][1], lastX, lastY, width, height);
				}
				
				// draw last row
				
			}
		}
		
		/**
		 * Clear the current graph environment.
		 * 
		 * @param	environment
		 */
		private static function clearGraph(environment:Group) : void
		{
			ToolTipManager.enabled = false;
			environment.removeAllElements(); //clear the previous graph
		}
		
		/**
		 * Draws a single node on the graph at the given location.
		 * 
		 * @param	environment
		 * @param	id
		 * @param	title
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		private static function drawSearchNode(environment:Group, index:int, id:String, title:String, x:int, y:int, width:int, height:int) : void
		{
			//TODO: make a more relevant node for search results...
			
			//FIXME: abstract tool tips do not work. Why not?
			//FIXME: clicking on a node does not request the graph for that node!
			
			var newNode:Node = new Node(environment, 0, new Number(index));
			
			newNode.id = id;
			
			newNode.title = "string";
			newNode.label = title;
			
			newNode.x = x;
			newNode.y = y;
			
			newNode.width = width;
			newNode.height = height;
			
			newNode.alpha = 1;
			
			environment.addElement(newNode);
		}
	}
}