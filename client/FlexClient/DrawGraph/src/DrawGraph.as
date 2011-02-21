package  
{
		import flash.text.TextField;
		import mx.containers.Canvas;
		import mx.controls.TextArea;
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
		
		public static function drawSplash(environment:Group):void {
			var hint:TextArea = new TextArea();
			hint.text = "Text ad da d dd a a d da \n and a dda";
			hint.x = 200;
			hint.y = 300;
			environment.addElement(hint);
		}
		
		//tells the program to draw a bunch of nodes in the drawing area
		public static function DrawG(a:Array, environment:Group):void {
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
				centerNode.id = a[0][0];
				centerNode.label = a[0][1];
				centerNode.width = environment.width/6;
				centerNode.height = environment.height/13;
				centerNode.x = (environment.width / 2) - (centerNode.width / 2);
				centerNode.y = (environment.height / 2) - (centerNode.height / 2);
				centerNode.alpha = 1;
				
				// draw lines and nodes
				var lineStyle:SolidColorStroke = new SolidColorStroke(0x222222, 2, 1);
				for (var i:Number = 1; i < 25 && i < a.length; i++) {
					var newNode:Node = new Node(environment,j,i);
					newNode.id = a[i][0];
					newNode.title = a[i][1];
					var title:String = new String(a[i][1]);
					newNode.label = title.split("_").join(" ");
					newNode.width = environment.width/8;
					newNode.height = environment.height/20;
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
				// add center node button
				environment.addElement(centerNode);
			}
			environment.visible = true;
		}	
	}
}