package  
{
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.text.engine.GroupElement;
		import flash.text.TextField;
		import mx.containers.Canvas;
		import mx.controls.TextArea;
		import mx.core.Application;
		import mx.core.IUIComponent;
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
		
		private static var nodes:Array;
		private static var centerNode:Node;
		private static var environment:Group;
		private static var lines:Array;
		
		/**
		 * Adjust these parameters to change the size and shape of the arrow heads.
		 */
		private static var ArrowHeadSlope : Number = 30;
		private static var ArrowHeadLength : Number = 15;
		
		// The first animation duration.
		private static var graphAnimationDuration :  Number = 1.5;
		
		//tells the program to draw a bunch of nodes in the drawing area
		public static function DrawG(a:Array, graph:Graph, showAnim : Boolean = true):void 
		{
			ToolTipManager.enabled = false;
			environment = graph.returnGraph();
			
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
				var h : Number = environment.width / 16;
				
				centerNode = makeNode(
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
					
				nodes = new Array();
				lines = new Array();
				
				// draw lines and nodes
				
				// default node width, height, and start position
				w = environment.width / 8;
				h = environment.height / 24;
				var x : Number = (environment.width / 2) - (w / 2);
				var y : Number = (environment.height / 2) - (h / 2);
				
				for (var i : Number = 1; i < 25 && i < a.length; i++) 
				{
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
						
						if (!showAnim)
						{
							if (a.length == 25) {
								var offset:Number = getOffset(a, newNode, i);
								newNode.x = newNode.getX(0.40, newNode, offset);
								newNode.y = newNode.getY(0.40, newNode, offset);
							}else {
								newNode.x = newNode.getX(0.40, newNode, 0);
								newNode.y = newNode.getY(0.40, newNode, 0);
							}
						}
						
						environment.addElement(newNode);
						nodes.push(newNode);
					}
				}
				// set graph environment is visible
				environment.visible = true;
				
				// animate nodes to the correct position
				if (showAnim)
				{
					openGraph();
				}
				
				// If no animation, just draw the lines.
				else
				{
					drawLines(nodes, centerNode, environment);
				}
				
				// add center node button
				environment.addElement(centerNode);
			}
			
		}
		
		/**
		 * get offset value to make graph nodes are not overlap
		 * 
		 * @param	a
		 * @param	newNode
		 * @param	i
		 * @return
		 */
		private static function getOffset(a:Array, newNode:Node, i:Number):Number {
			if (a.length > 24) {
				i--;
			}
			if (i > 0 && i < 6 || i > 12 && i < 18) {
				return -0.05;
			}else if (i > 6 && i < 12 || i > 18 && i < 24) {
				return 0.05;
			}else {
				return 0;
			}
		}
		
		/**
		 * Returns true if the source node has the destination node in its destination
		 * list.
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function areNodesRelated(destination : Node, source : Node) : Boolean {
			for (var dest_count : Number = 0; dest_count < source.dest.length; dest_count++) 
			{ 
				if (Number(source.dest[dest_count]) == Number(destination.id)) 
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Draw the line that connects the nodes, and needed arrow heads.
		 * 
		 * @param	node
		 * @param	centerNode
		 * @param	newLine
		 */
		private static function drawArrowLine(node : Node, centerNode : Node, newLine : UIComponent) : void
		{
			var inX : Number = node.getX(0.1, node, 0) + node.width / 2;
			var inY : Number = node.getY(0.1, node, 0) + node.height / 2;
			
			var x : Number = centerNode.x + (centerNode.width / 2);
			var y : Number = centerNode.y + (centerNode.height / 2);
			
			var outX : Number = getOuterX(node, x, y);
			var outY : Number = getOuterY(node, x, y);
			
			newLine.graphics.moveTo(inX, inY);
			newLine.graphics.lineTo(outX, outY);
		
			if (isPointsIn(centerNode, node))
			{
				drawArrowHead(outX, outY, inX, inY, newLine);
			}
			
			if (isPointsOut(centerNode, node))
			{
				drawArrowHead(inX, inY, outX, outY, newLine);
			}
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
			
			for (var i:Number = 0; i < nodes.length; i++) 
			{
				drawArrowLine(nodes[i], centerNode, newLine);
			}
			
			environment.addElement(newLine);
			lines.push(newLine);
		}
		
		/**
		 * Draw an arrow head pointing at (dstX, dstY).
		 * 
		 * See: http://stackoverflow.com/questions/2505853/flex-drawing-a-connector-line-between-shapes/2508990#2508990
		 * 
		 * @param	srcX
		 * @param	srcY
		 * @param	dstX
		 * @param	dstY
		 * @param	newLine
		 */
		private static function drawArrowHead(
			srcX : Number, 
			srcY : Number, 
			dstX : Number,
			dstY : Number,
			newLine : UIComponent) : void
		{
			var vector : Point = new Point( -(dstX - srcX), -(dstY - srcY));
			
			var edgeOneMatrix : Matrix = new Matrix();
			edgeOneMatrix.rotate(ArrowHeadSlope * Math.PI / 180);
			var edgeOneVector : Point = edgeOneMatrix.transformPoint(vector);
			edgeOneVector.normalize(ArrowHeadLength);
			
			var edgeOne : Point = new Point();
			edgeOne.x = dstX + edgeOneVector.x;
			edgeOne.y = dstY + edgeOneVector.y;
			
			var edgeTwoMatrix : Matrix = new Matrix();
			edgeTwoMatrix.rotate((0 - ArrowHeadSlope) * Math.PI / 180);
			var edgeTwoVector : Point = edgeTwoMatrix.transformPoint(vector);
			edgeTwoVector.normalize(ArrowHeadLength);
			
			var edgeTwo : Point = new Point();
			edgeTwo.x = dstX + edgeTwoVector.x;
			edgeTwo.y = dstY + edgeTwoVector.y;
			
			newLine.graphics.moveTo(dstX, dstY);
			newLine.graphics.lineTo(edgeOne.x, edgeOne.y);
			
			newLine.graphics.moveTo(dstX, dstY);
			newLine.graphics.lineTo(edgeTwo.x, edgeTwo.y);
		}
		
		/**
		 * Calculate the outer x coordinate for the connecting line.
		 * 
		 * @param	node
		 * @param	srcX
		 * @param	srcY
		 * @return
		 */
		private static function getOuterX(node : Node, srcX : Number, srcY : Number) : Number
		{
			// Calculate center of the node
			var halfW : Number = node.width / 2;
			var halfH : Number = node.height / 2;
			
			var x : Number = node.x + halfW;
			var y : Number = node.y + halfH;
			
			// Calculate distance from center node (srcX, srcY)
			var lenX : Number = Math.abs(x - srcX);
			var lenY : Number = Math.abs(y - srcY);
			
			// Calculate the x offset, where the arrow head should touch the node.
			var xDiff : Number = (node.height / 2) * (lenX / lenY);
			
			xDiff = (halfW < xDiff) ? halfW : xDiff;
			
			// Return the point at which the arrow should kiss the node.
			if (x < srcX)
			{
				return x + xDiff;
			}
			else
			{
				return x - xDiff;
			}
		}
		
		/**
		 * Calculate the outer y coordinate for the given node.
		 * 
		 * @param	node
		 * @param	srcX
		 * @param	srcY
		 * @return
		 */
		private static function getOuterY(node : Node, srcX : Number, srcY : Number) : Number
		{
			// Calculate center of the node
			var halfW : Number = node.width / 2;
			var halfH : Number = node.height / 2;
			
			var x : Number = node.x + halfW;
			var y : Number = node.y + halfH;
			
			// Calculate distance from center node (srcX, srcY)
			var lenX : Number = Math.abs(x - srcX);
			var lenY : Number = Math.abs(y - srcY);
			
			// Calculate the x offset, where the arrow head should touch the node.
			var yDiff : Number = (node.width / 2) * (lenY / lenX);
			
			yDiff = (halfH < yDiff) ? halfH : yDiff;
			
			// Return the point at which the arrow should kiss the node.
			if (y < srcY)
			{
				return y + yDiff;
			}
			else
			{
				return y - yDiff;
			}
		}
		
		/**
		 * Returns true if there is incoming relationship
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function isPointsIn(centerNode : Node, newNode : Node) : Boolean 
		{
			return areNodesRelated(centerNode, newNode);
		}
		
		/**
		 * Returns true if there is outgoing relationship
		 * 
		 * @param	centerNode
		 * @param	newNode
		 * @return
		 */
		private static function isPointsOut(centerNode : Node, newNode : Node) : Boolean 
		{
			return areNodesRelated(newNode, centerNode);
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
			
			node.setStyle("cornerRadius", node.height / 2);
			
			if (index != 0 || node.title.length < 12) { //settings for normal nodes or a center node with a low length
				node.label.y = node.height / 5;
				node.label.setStyle("fontSize", node.height / 3);
				node.label.setStyle("fontWeight", "normal");
			} else { //settings for the center nodes with long lengths
				node.label.y = node.height / 3.5;
				node.label.setStyle("fontSize", node.height / 5);
				node.label.setStyle("fontWeight", "bold");
			}
			
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
		private static function openGraph():void {
			trace("DrawGraph.openGraph");
			
			var lastFn : Function = function () : void {
				DrawGraph.drawLines(nodes, centerNode, environment)
			};
			
			for (var i:Number = 0; i < nodes.length; i++) {
				var node:Node = nodes[i];
				var offset:Number = getOffset(nodes, node, i);
				if ( i == nodes.length - 1)
				{
					TweenLite.to(
						node, 
						DrawGraph.graphAnimationDuration, 
						{ 
							x: node.getX(0.40, node, offset), 
							y: node.getY(0.40, node, offset), 
							ease: Back.easeInOut,
							onComplete: lastFn
						});
				}
				else
				{
					if (nodes.length == 24) {
						tween(node, offset);
					}else {
						tween(node, 0);
					}
				}
			}
			
			// After the first animation, speed up the animations so that they are not
			// distracting.
			DrawGraph.graphAnimationDuration = 0.85;
		}
		
		/**
		 * calls TweenLite to move given node to position x, y
		 * 
		 * @param	node
		 * @param	offset
		 */
		private static function tween(node:Node, offset:Number):void {
			TweenLite.to(
						node, 
						DrawGraph.graphAnimationDuration, 
						{ 
							x: node.getX(0.40, node, offset), 
							y: node.getY(0.40, node, offset), 
							ease: Back.easeInOut
						});
		}
		
		/**
		 * wipe the nodes & lines arrays, as they interfere with the close graph animation
		 */
		public static function clearData():void {
			nodes = null;
			lines = null;
		}
		
		/**
		 * moves all the nodes around to center node
		 */
		public static function closeGraph():void {
			// only do this if we're using a graph screen, doesn't work with search
			if(lines != null && nodes != null) {
			trace("DrawGraph.closeGraph");
			
			// remove lines
			for (var j:Number = 0; j < lines.length; j++) {
					environment.removeElement(lines[j]);
				}
				
				// moves nodes to center
				for (var i:Number = 0; i < nodes.length; i++) {
					var node:Node = nodes[i];
					
						TweenLite.to(
							node, 
							0.5, 
							{ 
								x: (environment.width / 2) - (node.width / 2), 
								y: (environment.height / 2) - (node.height / 2), 
								ease: Linear.easeInOut
							});
				}
			}
		}
	}
	
	
}