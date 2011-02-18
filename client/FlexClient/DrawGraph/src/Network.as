package  
{
	
	/**
	 * ...
	 * @author Michael Rush
	 */
	public class Network 
	{
		import mx.controls.Alert;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.xml.XMLNode;
		import spark.components.Group;
		
		private static var myXML:XML;
		private static var myLoader:URLLoader;
		private static var XMLOutput:XML;
		public static var env:Group;
		private static var list:Array;
		
		//Redirects a search request to the appropriate URL with the corresponding arguments
		public static function search(type:String, arg:String, qq:Group):void {
			env = qq;
			if (type == "name") {
				requestData("http://wikigraph.cs.washington.edu/api/graph/?q=" + arg);
			}
			else if (type == "id") {
				requestData("http://wikigraph.cs.washington.edu/api/graph/" + arg);
			} 
			else if (type == "autocomplete") {
				requestData("http://wikigraph.cs.washington.edu/api/autocomplete/" + arg);
			}
		}	
		
		//Does a URL request to the server and attempts to recieve an XML response.
		public static function requestData(xmlFile:String):void {
			myXML = new XML();
			var myXMLURL:URLRequest = new URLRequest(xmlFile);
			myLoader = new URLLoader(myXMLURL);
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            myLoader.load(myXMLURL);
		}
		
		//If the URL request was a success, then
		//Passes the XML to the parser to recieve a parsed list of nodes.
		//Passes the parsed list of nodes to the drawer to draw the nodes to the UI
		public static function xmlLoaded(event:Event):void {
			myXML = XML(myLoader.data);
			list = Parse.parseXML(myXML);
			DrawGraph.DrawG(list, env);
		}
		
		//If the URL request was a failure, then
		//Alerts the user if the page could not be found
		public static function errorHandler(event:Event):void {
			Alert.show("Could not find requested page");
		}



		
		
		
	}

}