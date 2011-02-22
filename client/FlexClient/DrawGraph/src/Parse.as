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
			for (var i:Number = 0; i < node.length(); i++) {
				var a:Array = new Array();
				a[0] = node[i].attribute("id");
				a[1] = node[i].attribute("title");
				list.push(a);
			}
			return list;
		}
		
		public static function parseAbs(myXML:XML):String {
			var abstract:String = new String();
			var node:XML = myXML.children();
			abstract = node.attribute("abstract");
			return abstract;
		}
		
		public static function parseAutoComplete(myXML:XML):Array {
			var children:XMLList = myXML.children();
			var list:Array = new Array();
			for (var i:Number = 0; i < children.length(); i++) {
				list[i] = children[i].attribute("title").toString();
			}
			return list;
		}
	}
}