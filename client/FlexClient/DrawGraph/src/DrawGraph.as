package  
{
		import flash.text.engine.GroupElement;
		import flash.text.TextField;
		import mx.containers.Canvas;
		import mx.controls.TextArea;
		import mx.core.Application;
		import mx.core.UIComponent;
		import mx.effects.Tween;
		import mx.graphics.SolidColorStroke;
		import mx.graphics.Stroke;
		import spark.components.Group;
		import spark.primitives.Line;
		import mx.controls.Alert;
		import mx.managers.ToolTipManager;
		
		
		import com.greensock.TweenLite;
		import com.greensock.easing.*;
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
		
		private static var j:Number;
		
		// The first animation duration.
		private static var graphAnimationDuration :  Number = 2;
		
		//tells the program to draw a bunch of nodes in the drawing area
		public static function DrawG(a:Array, graph:Graph):void 
		{
			ToolTipManager.enabled = false;
			var environment : Group = graph.returnGraph();
			
			if (a.length > 0) {
				environment.removeAllElements(); //clear the previous graph
				
				// calculate the node's postion
				
				if (a.length > 25 || a.length==1) {
					j = (2 * Math.PI) / 24;
				}else{
					j = (2 * Math.PI) / (a.length - 1);
				}
				
				//the center node is created first, since it always belongs in the middle
				var w : Number = environment.width / 6;
				var h : Number = environment.width / 13;
				
				var centerNode : Node = makeNode(
					graph, 
					j, 
					0, 
					a[0][0], 
					a[0][1], 
					a[0][2] == Number(1),
					a[0][3],
					w,
					h,
					(environment.width / 2) - (w / 2),
					(environment.height / 2) - (h / 2));
					
				var nodes:Array = new Array();
				
				// draw lines and nodes
				
				// default node width, height, and start position
				w = environment.width / 8;
				h = environment.height / 24;
				var x : Number = (environment.width / 2) - (w / 2);
				var y : Number = (environment.height / 2) - (h / 2);
				
				for (var i:Number = 1; i < 25 && i < a.length; i++) {
					var lengthCheck:String = a[i][1];
					if (lengthCheck.length > 0) {
						
						var newNode : Node = makeNode(
							graph, 
							j, 
							i, 
							a[i][0], 				// id
							a[i][1], 				// title
							a[i][2] == Number(1),  	// isDisambiguation
							a[i][3],				// destination nodes
							w,
							h,
							x,
							y);
						
						environment.addElement(newNode);
						nodes.push(newNode);
					}
				}
				// set graph environment is visible
				environment.visible = true;
				
				// animate nodes to the correct position
				openGraph(nodes, centerNode, environment);
				
				// add center node button
				environment.addElement(centerNode);
			}
			
		}
		
		/**
		 * Create a new node with the given parameters.
		 * 
		 * @param	graph
		 * @param	j
		 * @param	index
		 * @param	id
		 * @param	title
		 * @param	isDisambiguation
		 * @param	dest
		 * @param	width
		 * @param	height
		 * @param	x
		 * @param	y
		 * @return
		 */
		private static function makeNode(
			graph : Graph, 
			j : Number, 
			index : Number,
			id : String,
			title : String,
			isDisambiguation : Boolean,
			dest : Array,
			width : Number,
			height : Number,
			x : Number,
			y : Number) : Node 
		{
			var node:Node = new Node(graph, j, index); 
			
			node.id = id;
			node.label.text = title;
			node.title = title;
			node.is_disambiguation = isDisambiguation;
			trace(isDisambiguation);
			if (!isDisambiguation) {
				node.setStyle("color", 0x444444);
			} else {
				node.setStyle("color", 0x669966);
			}
			
			node.dest = dest;
			
			node.width = width;
			node.height = height;
			
			node.label.width = node.width;
			node.label.height = node.height;
			node.label.y = node.height / 5;
			
			node.setStyle("cornerRadius", node.height / 2);
			node.label.setStyle("fontSize", node.height / 3);
			
			node.x = x;
			node.y = y;
			
			node.alpha = 1;
			
			return node;
		}

		
		/**
		 * Stretches out graph nodes from the center to their final destination.
		 * The first animation takes 2s while all subsequent animations will take
		 * 1s.
		 * 
		 * This is an old video game trick so that the animations do not become 
		 * distracting for users.
		 * 
		 * @param	nodes
		 * @param	environment
		 */
		private static function openGraph(nodes:Array, centerNode : Node, environment:Group):void {
			trace("DrawGraph.openGraph");
			
			var lastFn : Function = function () : void {
				DrawGraph.drawLines(nodes, centerNode, environment)
			};
			
			for (var i:Number = 0; i < nodes.length; i++) {
				var node:Node = nodes[i];
				
				if ( i == nodes.length - 1)
				{
					TweenLite.to(
						node, 
						DrawGraph.graphAnimationDuration, 
						{ 
							x: node.getX(0.40, node,0), 
							y: node.getY(0.40, node,0), 
							ease: Back.easeInOut,
							onComplete: lastFn
						});
				}
				else
				{
					TweenLite.to(
						node, 
						DrawGraph.graphAnimationDuration, 
						{ 
							x: node.getX(0.40, node,0), 
							y: node.getY(0.40, node,0), 
							ease: Back.easeInOut
						});
				}
			}
			
			// After the first animation, speed up the animations so that they are not
			// distracting.
			DrawGraph.graphAnimationDuration = 1;
		}
		
		/**
		 * draws out arrow start from center node to others with arrows
		 * 
		 * @param	nodes
		 * @param	environment
		 */
		private static function drawLines(nodes:Array, centerNode:Node, environment:Group):void {
			trace("DrawGraph.drawLines");
			
			var newLine:UIComponent = new UIComponent();
			newLine.graphics.lineStyle(3, 0x666666, 1);	
			
			for (var i:Number = 0; i < nodes.length; i++) {
				var node:Node = nodes[i];
				
				// get three points of in arrow
				var inX:Number = node.getX(0.15, node,0)+node.width/2;
				var inY:Number = node.getY(0.15, node,0) + node.height / 2;
				var inArrowX1:Number = node.getX(0.18, node, 0.05) + node.width / 2;
				var inArrowY1:Number = node.getY(0.18, node, 0.05) + node.height / 2;
				var inArrowX2:Number = node.getX(0.18, node, -0.05) + node.width / 2;
				var inArrowY2:Number = node.getY(0.18, node, -0.05) + node.height / 2;
				
				// get three points of out arrow
				var outX:Number = node.getX(0.32, node,0)+node.width/2;
				var outY:Number = node.getY(0.32, node,0)+node.height/2;
				var outArrowX1:Number = node.getX(0.29, node, 0.05) + node.width / 2;
				var outArrowY1:Number = node.getY(0.29, node, 0.05) + node.height / 2;
				var outArrowX2:Number = node.getX(0.29, node, -0.05) + node.width / 2;
				var outArrowY2:Number = node.getY(0.29, node, -0.05) + node.height / 2;
				
				// draws line from in to out arrow
				newLine.graphics.moveTo(inX, inY);
				newLine.graphics.lineTo(outX, outY);
				
				if(isPointsIn(centerNode, node)){
					// draws in arrow
					newLine.graphics.moveTo(inX, inY);
					newLine.graphics.lineTo(inArrowX1, inArrowY1);
					newLine.graphics.moveTo(inX, inY);
					newLine.graphics.lineTo(inArrowX2, inArrowY2);
				}
				
				if(isPointsOut(centerNode, node)){
					// draws out arrow
					newLine.graphics.moveTo(outX, outY);
					newLine.graphics.lineTo(outArrowX1, outArrowY1);
					newLine.graphics.moveTo(outX, outY);
					newLine.graphics.lineTo(outArrowX2, outArrowY2);
				}
				
				environment.addElement(newLine);
			}
		}
		
		/**
		 * returns true if there is incoming or outcoming relationship
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function isPointsInOrOut(centerNode:Node, newNode:Node):Boolean {
			for (var dest_count : Number = 0; dest_count < newNode.dest.length; dest_count++) { 
				if (Number(newNode.dest[dest_count]) == Number(centerNode.id)) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * return true if there is incoming relationship
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function isPointsIn(centerNode:Node, newNode:Node):Boolean {
			return isPointsInOrOut(centerNode, newNode);
		}
		
		/**
		 * return true if there is outcoming relationship
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function isPointsOut(centerNode:Node, newNode:Node):Boolean {
			return isPointsInOrOut(newNode, centerNode);
		}
		
		
	}
}