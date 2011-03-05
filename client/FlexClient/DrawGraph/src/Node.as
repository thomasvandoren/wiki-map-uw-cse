package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Button;
	import mx.controls.Label;
	import spark.components.BorderContainer;
	import spark.components.Group;
	import mx.states.SetStyle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class Node extends BorderContainer 
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
		public var label:Label;
		public var is_disambiguation:Boolean;
		public var dest:Array;
		
		private var clickTimer : Timer;
		private var lockTimer : Timer;
		private var locked : Boolean = false;
		
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
			this.abstractTimer.addEventListener(TimerEvent.TIMER, timerDing);
			
			//set up mouse events
			this.doubleClickEnabled = true;
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK, openArticle, false, 2);
			this.addEventListener(MouseEvent.CLICK, getGraph);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, GetArticle);
			this.addEventListener(MouseEvent.MOUSE_OUT, StopTimer);
			
			//set up abstract toolTip creation
			this.tipCreated = false;
			this.angleDiffer = angleDiffer;
			this.index = index;
			
			//create the text
			this.label = new Label();
			this.addElement(label);
			
			//style the node
			this.label.setStyle("textAlign", "center")
			this.setStyle("backgroundColor", 0xEEEEEE);
			this.setStyle("borderWeight", 2);
			this.setStyle("borderColor", 0xBBBBBB);
		}
		
		/**
		 * Lock the node, preventing graph requests for a bit.
		 * 
		 * @param	event
		 */
		private function lock(event : TimerEvent = null) : void
		{
			this.locked = true;
		}
		
		/**
		 * Unlock the node and allow graph requests.
		 * 
		 * @param	event
		 */
		private function unlock(event : TimerEvent = null) : void
		{
			this.locked = false;
		}
		
		/**
		 * Tries to open the article with the tooltip opener (and the link
		 * that the services would have sent back). Otherwise it opens generates
		 * a url based on the base url in the config file and the title.
		 * 
		 * @param	event
		 */
		private function openArticle(event : MouseEvent) : void
		{
			lock();
			
			lockTimer = new Timer(650, 1);
			lockTimer.addEventListener(TimerEvent.TIMER_COMPLETE, unlock);
			lockTimer.start();
			
			if (this.abToolTip != null && this.abToolTip.articleLink != null)
			{
				this.abToolTip.openArticle(event);
			}
			else
			{
				var url : URLRequest = new URLRequest(Config.wikiUrlBase + escape(this.title));
				navigateToURL(url, "_blank");
			}
		}
		
		/**
		 * User clicked on a node, wait 500ms so that a double click event can register
		 * if it is going to. Priority is given to double clicks.
		 * 
		 * @param	event
		 */
		private function getGraph(event:MouseEvent):void
		{
			clickTimer = new Timer(500, 1);
			clickTimer.addEventListener(TimerEvent.TIMER_COMPLETE, doGetGraph);
			clickTimer.start();
		}
		
		/**
		 * Get graph on a click event.
		 * 
		 * @param	event
		 */
		private function doGetGraph(event : TimerEvent) : void
		{
			if (!this.locked)
			{
				graph.getGraph(id);
			}
		}
		
		/**
		 * Indicates that the user has started hovering over the node
		 * 
		 * @param	event
		 */
		private function GetArticle(event:MouseEvent):void
		{
			this.setStyle("backgroundColor", 0xE0E0FF); //change the color to indicate hover
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
		private function timerDing(event:TimerEvent):void
		{
			if (tipCreated) 
			{ 
				// Tip already created, simply return alpha and reset the timer
				abToolTip.abstractTimer.reset();
				abToolTip.visible = true;
				abToolTip.alpha = 0.9;
			} 
			else 
			{
				this.abToolTip = new AbstractToolTip(environment, label.text, id);
				
				this.tipCreated = true;
				this.abToolTip.setTitle = label.text;
				this.environment.addElement(abToolTip);
				this.setStyle(currentCSSState, 2);
				
				var xOffset : int = this.width / 3;
				var yOffset : int = 3;
				
				var meridian : int = environment.width / 2;
				var equator : int = environment.height / 2;
				
				// if the node is in first quadrant, then its tool tip is displayed below left
				if (this.x >= meridian && this.y < equator) 
				{
					abToolTip.x = this.x - abToolTip.width + xOffset;
					abToolTip.y = this.y + this.height + yOffset;
				}
				// Second quad: tool tip is below right
				else if (this.x < meridian && this.y < equator)
				{
					abToolTip.x = this.x + 2*xOffset;
					abToolTip.y = this.y + this.height + yOffset;
				}
				// Third quad: tool tip is above right
				else if (this.x < meridian && this.y >= equator) 
				{
					abToolTip.x = this.x + 2*xOffset;
					abToolTip.y = this.y - abToolTip.height - yOffset;
				}
				// Fourth quad: tool tip is above left
				else 
				{
					abToolTip.x = this.x - abToolTip.width + xOffset;
					abToolTip.y = this.y - abToolTip.height - yOffset;
				}
			}
		}
		
		/**
		 * User stopped hovering over node, stop the toolTip creation/reinsertion
		 * 
		 * @param	event
		 */
		private function StopTimer(event:MouseEvent):void
		{
			this.setStyle("backgroundColor", 0xEEEEEE); //change the color to indicate no_hover
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
		public function getX(ratio:Number, obj:Object, offsetAngle:Number):Number {
			return ((Math.cos((index - 1) * angleDiffer + offsetAngle)) * environment.width * ratio) + (environment.width / 2) - obj.width/2;
		}
		
		/**
		 * Returns Y position of this graph's node
		 * 
		 * @param	ratio
		 * @param	obj
		 * @return
		 */
		public function getY(ratio:Number, obj:Object, offsetAngle:Number):Number {
			return ((Math.sin((index - 1) * angleDiffer +offsetAngle)) * environment.height * ratio) + (environment.height / 2) - obj.height/2;
		}
	}
}