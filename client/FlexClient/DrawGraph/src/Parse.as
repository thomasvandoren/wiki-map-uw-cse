package {
	
	public class Parse {
		
		/**
		 * Parses a graph XML document and returns an array of array with the relevant information.
		 * 
		 * @param	myXML
		 * @return
		 */
		import mx.controls.Alert;
		public static function parseGraph(myXML : XML) : Array
		{
			if (myXML.name() != "graph")
			{
				throw new Error("invalid graph xml format");
			}
			
			var list : Array = new Array();
			
			// gets all children, called source, in a xml file
			var node:XMLList = myXML.child("source");
			
			// puts all the children's id & title in two dimention array called list
			for (var i:Number = 0; i < node.length(); i++) 
			{
				var a : Array = new Array();
				
				a[0] = node[i].@id;
				a[1] = node[i].@title;
				
				a[2] = node[i].@is_disambiguation;
				
				var dest : XMLList = node[i].child("dest");
				
				var b : Array = new Array();
				
				for (var j:Number = 0; j < dest.length(); j++) 
				{
					//add id's to the list
					b.push(dest[j].@id.toString());
				}
				
				a[3] = b;
				
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
		public static function parseAbstract(myXML:XML) : Abstract 
		{
			
			if (myXML.name() != "info")
			{
				throw new Error("invalid abstract xml format");
			}
			
			if (myXML.child("title").length() != 1)
			{
				throw new Error("invalid abstract xml format : expects one title item");
			}
			
			if (myXML.child("abstract").length() != 1)
			{
				throw new Error("invalid abstract xml format : expects one abstract item");
			}
			
			if (myXML.child("link").length() != 1)
			{
				throw new Error("invalid abstract xml format : expects one link item");
			}
			
			return new Abstract(
				myXML.child("title")[0].toString(),
				myXML.child("abstract")[0].toString(),
				myXML.child("link")[0].toString());
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
			
			var list : Array = new Array();
			
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