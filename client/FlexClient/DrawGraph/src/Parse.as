package{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	public class Parse {
		private static var list:Array;
		private static var myXML:XML;
		private static var myLoader:URLLoader;
		
		public static function parseXML(myXML:XML):Array {
			list = new Array();
			
			// gets all children, called source, in a xml file
			var node:XMLList = myXML.children();
			
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
		public static function parseAbs(myXML:XML):String {
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
			
			if (children.length() == 0)
			{
				throw new Error("malformed XML");
			}
			
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