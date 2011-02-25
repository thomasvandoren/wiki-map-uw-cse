package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Button;
	import spark.components.Group;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class Node extends Button 
	{	
		import Network;
		import AbstractToolTip;
		
		private var graph : Graph;
		
		public var environment:Group; //the drawing area (group) where the node goes
		public var abstractTimer:Timer; //after hovering for a certain amount of time, display the abstract
		public var abToolTip:AbstractToolTip; //the abstract toolTip object
		public var tipCreated:Boolean; //specifies whether the toolTip needs to be created (false = not made)		
		// angle different between one node to next node
		private var angleDiffer:Number;
		// index of this graph's node
		private var index:Number;
		public var title:String;
		
		/**
		 * Construct a new node. The environment it's created in must be specified
		 * if we change this from a button, we'll modify it so it accepts text too
		 * 
		 * @param	environment
		 * @param	angleDiffer
		 * @param	index
		 */
		public function Node(graph : Graph, angleDiffer : Number, index : Number) 
		{	
			this.graph = graph;
			this.environment = graph.returnGraph();
			
			//set up timer
			this.abstractTimer = new Timer(500, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			
			//set up mouse events
			addEventListener(MouseEvent.CLICK, getGraph);
			addEventListener(MouseEvent.MOUSE_OVER, GetArticle);
			addEventListener(MouseEvent.MOUSE_OUT, StopTimer);
			
			//set up abstract toolTip creation
			this.tipCreated = false;
			this.angleDiffer = angleDiffer;
			this.index = index;
		}
		
		/**
		 * User clicked on a node, retrieve the and draw the graph.
		 * 
		 * @param	event
		 */
		private function getGraph(event:MouseEvent):void
		{
			graph.getGraph(id);
		}
		
		/**
		 * Indicates that the user has started hovering over the node
		 * 
		 * @param	event
		 */
		private function GetArticle(event:MouseEvent):void
		{
			abstractTimer.start(); //starts the timer
			if (tipCreated) {
				abToolTip.abstractTimer.reset(); //resets the toolTip timer
				this.setStyle(currentCSSState, 2);
			}
		}
		
		/**
		 * Since the hold was long enough, now we need to create the toolTip
		 * 
		 * @param	event
		 */
		private function TimerDing(event:TimerEvent):void
		{
			if (tipCreated) 
			{ 
				// Tip already created, simply return alpha to 1 and reset the timer
				abToolTip.abstractTimer.reset();
				abToolTip.visible = true;
				abToolTip.alpha = 0.9;
			} 
			else 
			{ 
				//tip not created, do so now
				this.abToolTip = new AbstractToolTip(environment, label, id);
				
				if (angleDiffer == 0) 
				{
					// for first quardrant
					if (this.x > environment.width / 2 && this.y < environment.height/2) {
						abToolTip.x = this.x-abToolTip.width + 20;
						abToolTip.y = this.y + this.width/2;
					}else if(this.x < environment.width / 2 && this.y < environment.height/2){ // for 2nd
						abToolTip.x = this.x + this.width + 20;
						abToolTip.y = this.y + this.height/2;
					}else if (this.x < environment.width / 2 && this.y > environment.height / 2) { // for 3rd
						abToolTip.x = this.x + this.width + 20;
						abToolTip.y = this.y - abToolTip.height - 20;
					}else {
						abToolTip.x = this.x-abToolTip.width + 20;
						abToolTip.y = this.y - abToolTip.height - 20;
					}
				}
				else
				{
					if (index == 0) {
						abToolTip.x = getX(0.3, abToolTip);
						abToolTip.y = getY(0.3, abToolTip);
					}else{
						abToolTip.x = getX(0.1, abToolTip);
						abToolTip.y = getY(0.1, abToolTip);
					}
				}
				tipCreated = true;
				abToolTip.articleTitle = label;
				environment.addElement(abToolTip);
			}
			
			this.setStyle(currentCSSState, 2);
		}
		
		/**
		 * User stopped hovering over node, stop the toolTip creation/reinsertion
		 * 
		 * @param	event
		 */
		private function StopTimer(event:MouseEvent):void
		{
			abstractTimer.reset(); //sets the timer back to zero
			if (tipCreated) {
				abToolTip.abstractTimer.start(); //sets the toolTip timer to on
			}
		}
		
		/**
		 * Returns X position of this graph's node
		 * 
		 * @param	ratio
		 * @param	obj
		 * @return
		 */
		public function getX(ratio:Number, obj:Object):Number {
			return ((Math.cos((index - 1) * angleDiffer )) * environment.width * ratio) + (environment.width / 2) - (obj.width / 2);
		}
		
		/**
		 * Returns Y position of this graph's node
		 * 
		 * @param	ratio
		 * @param	obj
		 * @return
		 */
		public function getY(ratio:Number, obj:Object):Number {
			return ((Math.sin((index - 1) * angleDiffer )) * environment.height * ratio) + (environment.height / 2) - (obj.height / 2);
		}
	}
}