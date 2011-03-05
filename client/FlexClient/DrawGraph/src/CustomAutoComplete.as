package  
{
	/**
	 * This class creates and handles the autocomplete enabled search bar.
	 * 
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
		
		import Network;
		import Graph;
		
		private var myTimer:Timer;
		private var keyCount:int;
		private var ac:AutoComplete;
		private var searchText:TextInput;
		
		private var graph:Graph;
		private var env:Group;
		private var list:Array;
		private var isLocked : Boolean;
		
		public function CustomAutoComplete(environment:Group, g:Graph) 
		{
			graph = g;
			env = environment;
			this.unlock();
			
			//Initialize an inner AutoComplete component
			ac = new AutoComplete();
			ac.id = "ac";
			ac.requireSelection = true;
			ac.labelFunction = customLabelFunction;
			ac.x = 270;
			ac.y = 8;
			ac.addEventListener("select", handleSelect);
			ac.addEventListener(KeyboardEvent.KEY_DOWN, timerKeyHandler);
			environment.addElement(ac); 
			
			//Initialize a timer that will determine when the search queries occur
			myTimer = new Timer(500, 0);
            myTimer.addEventListener("timer", timerTickHandler);
			searchText = new TextInput();
		}
		
		//After .5 seconds (if no characters were typed), reset the timer and query the search
		private function timerTickHandler(event:Event):void {
			myTimer.reset();
			trace("TickHandler");
			timerHandler();
		}
		
		//After 4 characters have been pressed, query the search. Reset the timer on each character.
		private function timerKeyHandler(event:KeyboardEvent):void {
			if (event.keyCode != Keyboard.UP && 
				event.keyCode != Keyboard.DOWN && 
				event.keyCode != Keyboard.ENTER) 
			{
				keyCount = (keyCount + 1) % 4;
				if (myTimer.running == false) {
					myTimer.start();
				}
				if (keyCount == 3) {
					trace("KeyHandler");
					timerHandler();
				} else {
					myTimer.reset();
					myTimer.start();
				}
			}
			
		}
		
		//Query the search given in the autocomplete bar
		private function timerHandler():void {
			if (!this.isLocked)
			{
				searchText.text = ac.text;
				keyCount = 0;
				
				Network.autocompleteGet(searchText.text, this.loadResults, this.reportError);
			}
		}
		
		/**
		 * Receives the xml results from an autocomplete query. Sends them to the
		 * autocomplete data provider.
		 * 
		 * @param	data
		 */
		public function loadResults(data : XML) : void
		{
			ac.dataProvider = Parse.parseAutoComplete(data);
		}
		
		/**
		 * Report error to user if unable to complete request.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			Alert.show("Could not contact search service");
		}
		
		//Display results in the suggestions box according to title
		private function customLabelFunction(item:Object):String{
			return item[1].toString();
		}
		
		//Search for the suggestion if the user pressed enter
		private function handleSelect(event:CustomEvent):void {
			var item:Object = event.data;
			trace("Selected " + item[1].toString());
			trace("Selected " + item[0].toString());
			
			this.graph.getGraph(item[0][0]);
		}
		
		//Resizes the search bar to extend across the application width
		public function reSize():void {
			ac.width = env.width - 160 - 216; //subtract search history and search button widths
		}
		
		//Returns the current text in the autocomplete bar
		public function getText():String {
			return searchText.text;
		}
		
		/**
		 * Clear the search bar text.
		 */
		public function clearText() : void
		{
			ac.text = "";
			searchText.text = "";
		}
		
		/**
		 * Set the autocomplete text to the search text.
		 */
		private function setText() : void
		{
			ac.text = searchText.text;
		}
		
		/**
		 * Lock the autocomplete so that cannot send service requests.
		 * SearchButton calls this while it is loading search results.
		 * This has the side effect of storing the search text as the autocomplete
		 * text.
		 */
		public function lock() : void
		{
			this.isLocked = true;
			this.setText();
		}
		
		/**
		 * Unlock the autocomplete so that it can make requests.
		 */
		public function unlock() : void
		{
			this.isLocked = false;
		}
	}

}