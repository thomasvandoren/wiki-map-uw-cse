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
		public var environment:Group; //the drawing area (group) where the node goes
		public var abstractTimer:Timer; //after hovering for a certain amount of time, display the abstract
		public var abToolTip:AbstractToolTip; //the abstract toolTip object
		public var tipCreated:Boolean; //specifies whether the toolTip needs to be created (false = not made)		
		// angle different between one node to next node
		private var angleDiffer:Number;
		// index of this graph's node
		private var index:Number;
		public var title:String;
		private function ChangeLabel(event:MouseEvent):void
		{
			Network.search("name", title, environment);
		}
		//indicates that the user has started hovering over the node
		private function GetArticle(event:MouseEvent):void
		{
			abstractTimer.start(); //starts the timer
			if (tipCreated) {
				abToolTip.abstractTimer.reset(); //resets the toolTip timer
				this.setStyle(currentCSSState, 2);
			}
		}
		//since the hold was long enough, now we need to create the toolTip
		private function TimerDing(event:TimerEvent):void
		{
			if (tipCreated) { //tip already created, simply return alpha to 1 and reset the timer
				abToolTip.abstractTimer.reset();
				abToolTip.visible = true;
				abToolTip.alpha = 0.6;
			} else { //tip not created, do so now
				this.abToolTip = new AbstractToolTip(environment, label, id);
				if (index == 0) {
					abToolTip.x = getX(0.3, abToolTip);
					abToolTip.y = getY(0.3, abToolTip);
				}else{
					abToolTip.x = getX(0.1, abToolTip);
					abToolTip.y = getY(0.1, abToolTip);
				}
				tipCreated = true;
				abToolTip.articleTitle = label;
				environment.addElement(abToolTip);
			}
			this.setStyle(currentCSSState, 2);
		}
		//user stopped hovering over node, stop the toolTip creation/reinsertion
		private function StopTimer(event:MouseEvent):void
		{
			abstractTimer.reset(); //sets the timer back to zero
			if (tipCreated) {
				abToolTip.abstractTimer.start(); //sets the toolTip timer to on
			}
		}
		//constructor class for node, the environment it's created in must be sepcified
		//if we change this from a button, we'll modify it so it accepts text too
		public function Node(environment:Group, angleDiffer:Number, index:Number) 
		{	//set up timer
			this.environment = environment;
			this.abstractTimer = new Timer(500, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			//set up mouste events
			addEventListener(MouseEvent.CLICK, ChangeLabel);
			addEventListener(MouseEvent.MOUSE_OVER, GetArticle);
			addEventListener(MouseEvent.MOUSE_OUT, StopTimer);
			//set up abstract toolTip creation
			this.tipCreated = false;
			this.angleDiffer = angleDiffer;
			this.index = index;
		}
		
		// returns X position of this graph's node
		public function getX(ratio:Number, obj:Object):Number {
			return ((Math.cos((index - 1) * angleDiffer )) * environment.width * ratio) + (environment.width / 2) - (obj.width / 2);
		}
		
		// returns Y position of this graph's node
		public function getY(ratio:Number, obj:Object):Number {
			return ((Math.sin((index - 1) * angleDiffer )) * environment.height * ratio) + (environment.height / 2) - (obj.height / 2);
		}
	}
}