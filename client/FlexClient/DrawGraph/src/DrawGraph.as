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
		public static function DrawG(a:Array, graph:Graph, cNode:Node):void 
		{
			
			ToolTipManager.enabled = false;
			var environment : Group = graph.returnGraph();
			
			if (a.length > 0) {
				environment.removeAllElements(); //clear the previous graph
				
				//presently this is how we're calculating the node's postion
				var j:Number;
				if (a.length > 25 || a.length==1) {
					j = (2 * Math.PI) / 24;
				}else{
					j = (2 * Math.PI) / (a.length - 1);
				}
				
				var centerNode:Node = new Node(graph,j,0); //the center node is created first, since it always belongs in the middle
				if(cNode != null) {
					centerNode.id = cNode.id;
					centerNode.label.text = cNode.label.text;
					centerNode.title = cNode.label.text;
				} else {
					centerNode.id = a[0][0];
					centerNode.label.text = a[0][1];
					centerNode.title = a[0][1];
				}
				centerNode.width = environment.width/6;
				centerNode.height = environment.height / 13;
				centerNode.label.width = centerNode.width;
				centerNode.label.height = centerNode.height;
				centerNode.label.y = centerNode.height / 4;
				centerNode.setStyle("cornerRadius", centerNode.height / 2);
				centerNode.label.setStyle("fontSize", centerNode.height / 3);
				centerNode.x = (environment.width / 2) - (centerNode.width / 2);
				centerNode.y = (environment.height / 2) - (centerNode.height / 2);
				centerNode.alpha = 1;

				// draw lines and nodes
				for (var i:Number = 1; i < 25 && i < a.length; i++) {
					var lengthCheck:String = a[i][1];
					if (lengthCheck.length > 0) {
					var newNode:Node = new Node(graph,j,i);
					newNode.id = a[i][0];
					newNode.title = a[i][1];
					var title:String = new String(a[i][1]);
					newNode.label.text = title.split("_").join(" ");
					newNode.width = environment.width/8;
					newNode.height = environment.height / 24;
					newNode.label.width = newNode.width;
					newNode.label.height = newNode.height;
					newNode.label.y = newNode.height / 6;
					newNode.setStyle("cornerRadius", newNode.height / 2);
					newNode.label.setStyle("fontSize", newNode.height / 3);
					newNode.x = newNode.getX(0.40, newNode);
					newNode.y = newNode.getY(0.40, newNode);
					newNode.alpha = 1;
					
					var newLine:UIComponent = new UIComponent();
					//some variables to make line drawing a bit easier
					var envX:Number = (environment.width / 2); //x center of the environment
					var envY:Number = (environment.height / 2); //y center of the environment
					var nodeX:Number = (newNode.x + newNode.width / 2); //x center of the node
					var nodeY:Number = (newNode.y + newNode.height / 2); //y center of the node
					var lineEndX:Number = ((nodeX - envX) * 0.8) + envX;
					var lineEndY:Number = ((nodeY - envY) * 0.9) + envY;
					var arrowX:Number = ((Math.cos((i - 1) * j + Math.PI/90)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
					var arrowY:Number = ((Math.sin((i - 1) * j + Math.PI/90)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
					arrowX = (((arrowX + newNode.width / 2) - envX) * 0.77) + envX;
					arrowY = (((arrowY + newNode.height / 2) - envY) * 0.87) + envY;
					var arrowA:Number = ((Math.cos((i - 1) * j - Math.PI/90)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
					var arrowB:Number = ((Math.sin((i - 1) * j - Math.PI/90)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
					arrowA = (((arrowA + newNode.width / 2) - envX) * 0.77) + envX;
					arrowB = (((arrowB + newNode.height / 2) - envY) * 0.87) + envY;
					
					//line color defined here
					newLine.graphics.lineStyle(3, 0x666666, 1);
					newLine.name = a[i][0] + "_line";
					newLine.graphics.moveTo(envX,envY);
					newLine.graphics.lineTo(lineEndX, lineEndY);
					newLine.graphics.lineStyle(3, 0x667766, 1);
					newLine.graphics.lineTo(arrowX, arrowY);
					newLine.graphics.moveTo(lineEndX, lineEndY);
					newLine.graphics.lineTo(arrowA, arrowB);
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
		
	}
}