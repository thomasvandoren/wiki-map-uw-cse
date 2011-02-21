package  
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	import spark.components.Group;
	import spark.primitives.Line;
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	//Just a quick splash page, will make it less crap later
	public class DrawSplash extends Sprite
	{	
		public static function DrawS(environment:Group):void 
		{
			environment.removeAllElements(); //clear everything in env
			var title:Text = new Text();
			title.x = (environment.width / 8);
			title.width = (environment.width / 8) * 6;
			title.y = (environment.height / 4);
			title.htmlText = "<font size = '64'><b>Wiki Graph</b></font><BR/>";
			title.htmlText += "<font size = '24'>Instructions</font><BR/>";
			title.htmlText += "<font size = '16'>1.Enter a search term in the search bar</font><BR/>";
			title.htmlText += "<font size = '16'>2.After the graph is drawn, click on nodes to traverse the graph</font><BR/>";
			title.htmlText += "<font size = '16'>3.Hover over nodes to see the article abstracts, click the abstract to go to the article</font><BR/>";
			environment.addElement(title);
		}
	}

}