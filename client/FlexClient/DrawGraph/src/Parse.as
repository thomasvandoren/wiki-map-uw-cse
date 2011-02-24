package{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	public class Parse {
		private static var list:Array;
		private static var myXML:XML;
		private static var myLoader:URLLoader;
		
		/**
		 * Parses a graph XML document and returns an array of array with the relevant information.
		 * 
		 * @param	myXML
		 * @return
		 */
		public static function parseGraph(myXML : XML) : Array
		{
			if (myXML.name() != "graph")
			{
				throw new Error("invalid graph xml format");
			}
			
			list = new Array();
			
			// gets all children, called source, in a xml file
			var node:XMLList = myXML.child("source");
			
			// puts all the children's id & title in two dimention array called list
			for (var i:Number = 0; i < node.length(); i++) 
			{
				var a:Array = new Array();
				
				a[0] = node[i].@id;
				a[1] = node[i].@title;
				
				list.push(a);
			}
			
			return list;
		}
		
		/**
		 * Parse abstract XML and return the text only.
		 * 
		 * @param	myXML
		 * @return
		 */
		public static function parseAbstract(myXML:XML):String {
			var node:XMLList = myXML.child("abstract");
			
			if (node.length() != 1)
			{
				throw new Error("invalid abstract XML");
			}
			
			return node[0].toString();
		}
		
		/**
		 * Parse the autocomplete results and returns an array.
		 * 
		 * @param	myXML
		 * @return
		 */
		public static function parseAutoComplete(myXML:XML) : Array 
		{
			if (myXML.name() != "list")
			{
				throw new Error("invalid autocomplete xml format ");
			}
			
			return parseAutocompleteSearchItems(myXML.child("item"));
		}
		
		/**
		 * Parse the search results and returns an array.
		 * 
		 * @param	myXML
		 * @return
		 */
		public static function parseSearch(myXML:XML) : Array  
		{
			if (myXML.name() != "search")
			{
				throw new Error("invalid search xml format");
			}
			
			return parseAutocompleteSearchItems(myXML.child("item"));
		}
		
		/**
		 * Parses all of the children (items) and returns an array of arrays.
		 * 
		 * items = Array ( Array (id, title) ) 
		 */
		private static function parseAutocompleteSearchItems(children:XMLList) : Array
		{
			
			list = new Array();
			
			// puts all the children's id & title in two dimention array called list
			for (var i:Number = 0; i < children.length(); i++) 
			{
				var a:Array = new Array();
				
				if (children[i].@id.length() != 1 || children[i].@title.length() != 1)
				{
					throw new Error("malformed XML");
				}
				
				a[0] = children[i].@id;
				a[1] = children[i].@title;
				
				list.push(a);
			}
			
			return list;
		}
	}
}