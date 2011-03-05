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
			
			node.dest = dest;
			
			node.width = width;
			node.height = height;
			
			node.label.width = node.width;
			node.label.height = node.height;
			node.label.y = node.height / 4;
			
			node.setStyle("cornerRadius", node.height / 2);
			node.label.setStyle("fontSize", node.height / 3);
			
			node.x = x;
			node.y = y;
			
			node.alpha = 1;
			
			return node;
		}
		
		/**
		 * draws arrows from center node to others
		 * 
		 * @param	nodes
		 * @param	environment
		 * @param	j
		 */
		private static function drawLines(nodes:Array, centerNode:Node, environment:Group):void {
			trace("DrawGraph.drawLines");
			
			for (var i : int = 0; i < nodes.length; i++)
			{
				var newNode : Node = nodes[i];
				
				var points_in:Boolean = false;
				var points_out:Boolean = false;
				
				for (var dest_count : Number = 0; dest_count < newNode.dest.length; dest_count++) 
				{ 
					//checks to see if there's incoming relationship
					if (Number(newNode.dest[dest_count]) == Number(centerNode.id)) 
					{
						points_in = true;
						break;
					}
				}
				for (dest_count = 0; dest_count < centerNode.dest.length; dest_count++) 
				{ 
					//checks to see if there's outgoing relationship
					if (Number(centerNode.dest[dest_count]) == Number(newNode.id)) 
					{
						points_out = true;
						break;
					}
				}
				
				var newLine:UIComponent = new UIComponent(); //the new line
				newLine.id = newNode.id + "_line"; //giving it an id in case we need it for animation
				//Calculations for where to put the lines/arrow heads
				var envX:Number = (environment.width / 2); //x center of the environment
				var envY:Number = (environment.height / 2); //y center of the environment
				var nodeX:Number = (newNode.x + newNode.width / 2); //x center of the node
				var nodeY:Number = (newNode.y + newNode.height / 2); //y center of the node
				var outEndX:Number = ((nodeX - envX) * 0.8) + envX;
				var outEndY:Number = ((nodeY - envY) * 0.9) + envY;
				var inEndX:Number = ((nodeX - envX) * 0.3) + envX;
				var inEndY:Number = ((nodeY - envY) * 0.3) + envY;
				//determine what to draw
				if (points_in && points_out) 
				{ 
					//mutual
					DrawArrowLine(outEndX, outEndY, inEndX, inEndY, newLine);
					DrawOutHead(outEndX, outEndY, newLine, i, environment, newNode);
					DrawInHead(inEndX, inEndY, newLine, i, environment, newNode);
				} 
				else if (points_in && !points_out) 
				{ 
					//in arrow
					outEndX = nodeX;
					outEndY = nodeY;
					DrawArrowLine(outEndX, outEndY, inEndX, inEndY, newLine);
					DrawInHead(inEndX, inEndY, newLine, i, environment, newNode);
				} 
				else if (!points_in && points_out) 
				{
					//out arrow
					inEndX = envX;
					inEndY = envY;
					DrawArrowLine(outEndX, outEndY, inEndX, inEndY, newLine);
					DrawOutHead(outEndX, outEndY, newLine, i, environment, newNode);
				}
				//actually draw the element
				environment.addElementAt(newLine, 0);
			}
		}
		
		/**
		 * Stretches out graph nodes from the center to their final destination.
		 * The first animation takes 2s while all subsequent animations will take
		 * 0.75s.
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
							x: node.getX(0.40, node), 
							y: node.getY(0.40, node), 
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
							x: node.getX(0.40, node), 
							y: node.getY(0.40, node), 
							ease: Back.easeInOut
						});
				}
			}
			
			// After the first animation, speed up the animations so that they are not
			// distracting.
			DrawGraph.graphAnimationDuration = 0.75;
		}
		
		/**
		 * draws out arrow start from center node to others with arrows
		 * 
		 * @param	nodes
		 * @param	environment
		 */
		private static function DrawOutArrow(nodes:Array, environment:Group):void {
			var newLine:UIComponent = new UIComponent();
			newLine.graphics.lineStyle(3, 0x666666, 1);	
			var envX:Number = (environment.width / 2); 
			var envY:Number = (environment.height / 2); 
			for (var i:Number = 0; i < nodes.length; i++) {
				var node:Node = nodes[i];
				
				var endX:Number = node.getX(0.32, node)+node.width/2;
				var endY:Number = node.getY(0.32, node)+node.height/2;
				// draws line from center node to others
				newLine.graphics.moveTo(envX, envY);
				newLine.graphics.lineTo(endX, endY);
				// draws arrow for each line
				// (will do later :D) 
				// I tried to use DrawOutArrow from what Austin had but didn't work for my animation.
				// The arrows are become a line start from center node. That's why I changed to my 
				// code to make it works with animation move nodes from left to right, however I 
				// don't know how to draw arrows now :D
				
				// Austin: Can you take a look and help me to add codes for this or change your code to make
				// my animation works? I will try to do it tomorrow but since you did this one so you will
				// figure it out faster than me :) Thanks.
				
				environment.addElementAt(newLine, 0);
			}
		}
		
		/**
		 * draw the arrow line
		 * 
		 * @param	outEndX
		 * @param	outEndY
		 * @param	inEndX
		 * @param	inEndY
		 * @param	newLine
		 */
		private static function DrawArrowLine(outEndX:Number, outEndY:Number, inEndX:Number, inEndY:Number, newLine:UIComponent):void {
			newLine.graphics.lineStyle(3, 0x666666, 1);
			newLine.graphics.moveTo(outEndX, outEndY);
			newLine.graphics.lineTo(inEndX, inEndY);
		}
		
		/**
		 * draw the outgoing arrow head
		 * 
		 * @param	outEndX
		 * @param	outEndY
		 * @param	newLine
		 * @param	i
		 * @param	environment
		 * @param	newNode
		 */
		private static function DrawOutHead(outEndX:Number, outEndY:Number, newLine:UIComponent, i:Number, environment:Group, newNode:Node):void {
			//Compute how to draw the arrow head
			var arrowX:Number = ((Math.cos((i) * j + Math.PI/90)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
			var arrowY:Number = ((Math.sin((i) * j + Math.PI/90)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
			arrowX = (((arrowX + newNode.width / 2) - (environment.width / 2)) * 0.77) + (environment.width / 2);
			arrowY = (((arrowY + newNode.height / 2) - (environment.height / 2)) * 0.87) + (environment.height / 2);
			var arrowA:Number = ((Math.cos((i) * j - Math.PI/90)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
			var arrowB:Number = ((Math.sin((i) * j - Math.PI/90)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
			arrowA = (((arrowA + newNode.width / 2) - (environment.width / 2)) * 0.77) + (environment.width / 2);
			arrowB = (((arrowB + newNode.height / 2) - (environment.height / 2)) * 0.87) + (environment.height / 2);
			//Draw the arrow head
			newLine.graphics.moveTo(outEndX, outEndY);
			newLine.graphics.lineTo(arrowX, arrowY);
			newLine.graphics.moveTo(outEndX, outEndY);
			newLine.graphics.lineTo(arrowA, arrowB);
		}
		
		/**
		 * draw the incoming arrow head
		 * 
		 * @param	outEndX
		 * @param	outEndY
		 * @param	newLine
		 * @param	i
		 * @param	environment
		 * @param	newNode
		 */
		private static function DrawInHead(inEndX:Number, inEndY:Number, newLine:UIComponent, i:Number, environment:Group, newNode:Node):void {
			//Compute how to draw the arrow head
			var arrowX:Number = ((Math.cos((i) * j + Math.PI/30)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
			var arrowY:Number = ((Math.sin((i) * j + Math.PI/30)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
			arrowX = (((arrowX + newNode.width / 2) - (environment.width / 2)) * 0.33) + (environment.width / 2);
			arrowY = (((arrowY + newNode.height / 2) - (environment.height / 2)) * 0.33) + (environment.height / 2);
			var arrowA:Number = ((Math.cos((i) * j - Math.PI/30)) * environment.width * 0.40) + (environment.width / 2) - (newNode.width / 2);
			var arrowB:Number = ((Math.sin((i) * j - Math.PI/30)) * environment.height * 0.40) + (environment.height / 2) - (newNode.height / 2);
			arrowA = (((arrowA + newNode.width / 2) - (environment.width / 2)) * 0.33) + (environment.width / 2);
			arrowB = (((arrowB + newNode.height / 2) - (environment.height / 2)) * 0.33) + (environment.height / 2);
			//Draw the arrow head
			newLine.graphics.moveTo(inEndX, inEndY);
			newLine.graphics.lineTo(arrowX, arrowY);
			newLine.graphics.moveTo(inEndX, inEndY);
			newLine.graphics.lineTo(arrowA, arrowB);
		}
	}
}