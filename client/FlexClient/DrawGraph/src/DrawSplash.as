package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	import spark.components.Group;
	import spark.primitives.Line;
	import mx.controls.Alert;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	//Just a quick splash page, will make it less crap later
	public class DrawSplash extends Sprite
	{	
		private static var isDrawn:Boolean = false;		
		public static function DrawS(environment:Group):void 
		{
			environment.removeAllElements(); //clear everything in env
			var title:Text = new Text();
			title.width = (environment.width / 3)*2;
			title.htmlText = "<font size = '64'><b>WikiGraph</b></font><BR/>";
			title.htmlText += "<font size = '24'>Instructions</font><BR/>";
			title.htmlText += "<font size = '16'>1. Enter a search term in the search bar</font><BR/>";
			title.htmlText += "<font size = '16'>2. Press enter, click search, or click a suggestion to draw the graph</font><BR/>";
			title.htmlText += "<font size = '16'>3. After the graph is drawn, click the outer nodes to traverse the graph</font><BR/>";
			title.htmlText += "<font size = '16'>4. Hover over nodes to view the article abstracts</font><BR/>";
			title.htmlText += "<font size = '16'>5. Click the abstract or double click the node to view the article</font><BR/>";
			title.visible = true;
			title.alpha = 1;
			environment.visible = true;
			environment.addElement(title);
			if (!isDrawn){
				title.x = -title.width;
				title.y = -title.height;
				TweenLite.to(title, 1, { x:environment.width / 4, y:environment.height / 4, delay:1 } );
			}else {
				title.x = environment.width / 4;
				title.y = environment.height / 4;
			}
			isDrawn = true;
		}
		
		public static function resize(environment:Group):void {
			DrawS(environment);
		}
	}
	

}