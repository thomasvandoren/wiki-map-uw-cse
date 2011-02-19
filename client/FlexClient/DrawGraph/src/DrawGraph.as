package  
{
		import mx.containers.Canvas;
		import mx.core.Application;
		import mx.core.UIComponent;
		import mx.graphics.SolidColorStroke;
		import mx.graphics.Stroke;
		import spark.components.Group;
		import spark.primitives.Line;
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
		public static function DrawG(a:Array, environment:Group):void {
			if (a.length > 0) {
				environment.removeAllElements(); //clear the previous graph
				var j:Number = (2 * Math.PI) / (a.length - 1); //presently this is how we're calculating the node's postion
				var centerNode:Node = new Node(environment); //the center node is created first, since it always belongs in the middle
				centerNode.id = a[0][0];
				centerNode.label = a[0][1];
				centerNode.width = 120;
				centerNode.height = 24;
				centerNode.x = (environment.width / 2) - (centerNode.width / 2);
				centerNode.y = (environment.height / 2) - (centerNode.height / 2);
				centerNode.alpha = 1;
				//draw lines, we do this because of depth issues and such
				var lineStyle:SolidColorStroke = new SolidColorStroke(0x222222, 2, 1);
				for (var k:Number = 1; k < a.length; k++) {
					var newLine:UIComponent = new UIComponent();
					//line color defined here
					newLine.graphics.lineStyle(3, 0x666666, 1);
					newLine.name = a[k][0] + "_line";
					//lines are drawn from the center to the center of each node
					var x:Number = ((Math.cos((k - 1) * j + (3*Math.PI / 2))) * environment.width * 0.42) + (environment.width / 2);
					var y:Number = ((Math.sin((k - 1) * j + (3*Math.PI / 2))) * environment.height * 0.42) + (environment.height / 2);
					newLine.graphics.moveTo((environment.width / 2), (environment.height / 2));
					newLine.graphics.lineTo(x, y);
					environment.addElement(newLine);
				}
				environment.addElement(centerNode);
				//draw nodes
				for (var i:Number = 1; i < a.length; i++) {
					var newNode:Node = new Node(environment);
					newNode.id = a[i][0];
					newNode.label = a[i][1];
					newNode.width = 120;
					newNode.height = 24;
					newNode.x = ((Math.cos((i - 1) * j + (3*Math.PI / 2))) * environment.width * 0.42) + (environment.width / 2) - (newNode.width / 2);
					newNode.y = ((Math.sin((i - 1) * j + (3 * Math.PI / 2))) * environment.height * 0.42) + (environment.height / 2) - (newNode.height / 2);
					newNode.alpha = 1;
					environment.addElement(newNode);
				}
			}
			environment.visible = true;
		}	
	}
}