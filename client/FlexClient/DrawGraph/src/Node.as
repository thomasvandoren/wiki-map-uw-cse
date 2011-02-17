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
		import AbstractToolTip;
		public var environment:Group; //the drawing area (group) where the node goes
		public var abstractTimer:Timer; //after hovering for a certain amount of time, display the abstract
		public var abToolTip:AbstractToolTip; //the abstract toolTip object
		public var tipCreated:Boolean; //specifies whether the toolTip needs to be created (false = not made)
		private function ChangeLabel(event:MouseEvent):void
		{
			label = "lolol";
		}
		//indicates that the user has started hovering over the node
		private function GetArticle(event:MouseEvent):void
		{
			abstractTimer.start(); //starts the timer
			if (tipCreated) {
				abToolTip.abstractTimer.reset(); //resets the toolTip timer
			}
		}
		//since the hold was long enough, now we need to create the toolTip
		private function TimerDing(event:TimerEvent):void
		{
			if (tipCreated) { //tip already created, simply return alpha to 1 and reset the timer
				abToolTip.abstractTimer.reset();
				abToolTip.alpha = 1;
			} else { //tip not created, do so now
			this.abToolTip = new AbstractToolTip(environment);
			abToolTip.x = (this.x) - (1.25 *(this.width));
			abToolTip.y = (this.y);
			tipCreated = true;
			//this.addChild(abToolTip);
			environment.addElement(abToolTip);
			}
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
		public function Node(environment:Group) 
		{	//set up timer
			this.environment = environment;
			this.abstractTimer = new Timer(1500, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			//set up mouste events
			addEventListener(MouseEvent.CLICK, ChangeLabel);
			addEventListener(MouseEvent.MOUSE_OVER, GetArticle);
			addEventListener(MouseEvent.MOUSE_OUT, StopTimer);
			//set up abstract toolTip creation
			this.tipCreated = false;
		}
	}
}