package  
{
	/**
	 * ...
	 * @author Michael Rush
	 */
	
	
	public class CustomAutoComplete 
	{		
		import flash.events.Event;
		import mx.controls.Alert;
		import mx.controls.TextInput;
		import org.flashcommander.event.CustomEvent;
		import flash.events.KeyboardEvent;
		import flash.utils.Timer;
		import org.flashcommander.components.AutoComplete;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.ui.Keyboard;
		import flash.events.IOErrorEvent;
		import spark.components.Group;
		
		private var myTimer:Timer;
		private var keyCount:int;
		private var ac:AutoComplete;
		private var searchText:TextInput;
		private var myLoader:URLLoader;
		private var myXMLURL:URLRequest;
		private var URL:String;
		private var graph:Group;
		private var env:Group;
		private var list:Array;
		
		public function CustomAutoComplete(environment:Group, g:Group) 
		{
			graph = g;
			env = environment;
			
			ac = new AutoComplete();
			ac.id = "ac";
			ac.requireSelection = true;
			ac.labelFunction = customLabelFunction;
			ac.x = 100;
			ac.y = 0;
			ac.width = 700;
			ac.addEventListener("select", handleSelect);
			ac.addEventListener(KeyboardEvent.KEY_DOWN, timerKeyHandler);
			environment.addElement(ac);
			
			
			myTimer = new Timer(500, 0);
            myTimer.addEventListener("timer", timerTickHandler);
			searchText = new TextInput();
			
			URL = "http://wikigraph.cs.washington.edu/api/autocomplete/";
			myXMLURL = new URLRequest(URL);
			myLoader = new URLLoader();
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function timerTickHandler(event:Event):void {
			myTimer.reset();
			trace("TickHandler");
			timerHandler();
		}
		
		private function timerKeyHandler(event:KeyboardEvent):void {
			if (myTimer.running == false) {
				myTimer.start();
			}
			if (event.keyCode != Keyboard.UP && event.keyCode != Keyboard.DOWN) {
				keyCount = (keyCount + 1) % 4;
			}
			if (keyCount == 3) {
				trace("KeyHandler");
				timerHandler();
			} else {
				myTimer.reset();
				myTimer.start();
			}
		}
		
		private function timerHandler():void {
			searchText.text = ac.text;
			keyCount = 0;
			myXMLURL.url = (URL + "?q=" + searchText.text)
			myLoader.load(myXMLURL);
		}
		
		//Sets the autocomplete dataprovider equal to the returns titles
		private function xmlLoaded(event:Event):void {
			var myXML:XML = XML(myLoader.data);
			ac.dataProvider = Parse.parseAutoComplete(myXML);
		}
		
		//If the URL request was a failure, then
		//Alerts the user if the page could not be found
		private static function errorHandler(event:Event):void {
			Alert.show("Could not contact search service");
		}
		
		private function customLabelFunction(item:Object):String{
			return item.toString();
		}
		
		private function handleSelect(event:CustomEvent):void {
			var item:Object = event.data;
			trace("Selected " + item.toString());
			Network.search("name", item.toString(), graph);
			ac.text = "";
		}
		
		public function reSize():void {
			ac.width = env.width - ac.x - 2;
		}
		
		public function getText():String {
			return searchText.text;
		}
	}

}