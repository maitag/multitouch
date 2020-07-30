package;

import lime.ui.Window;
import lime.ui.Touch;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.display.GradientType;
import openfl.geom.Matrix;

/**
 * Emulates Multitouch and visualizes Touchpoints
 * 
 * by Sylvio Sell, Rostock 2017
 * 
 */

class TouchEmulation extends Sprite
{
	var idState:Array<Bool>;
	var radius:Float;
	var device:Int;
	
	var lastX:Float;
	var lastY:Float;
	
	// callbacks
	var touchStart:Touch->Void;
	var touchMove:Touch->Void;
	var touchEnd:Touch->Void;
	
	var touchpoint:TouchPoint; // pressed touchpoint
	var moved:Bool;

	public function new(onTouchStart:Touch->Void, onTouchMove:Touch->Void, onTouchEnd:Touch->Void,
	                    maxTouchpoints:Int = 100, radius:Float = 16.0, device:Int = -1)
	{
		this.radius = radius;
		this.device = device;
		
		// set callbacks
		touchStart = onTouchStart;
		touchMove = onTouchMove;
		touchEnd = onTouchEnd;
		
		// default is for max ten peoples with 10 Fingers (or a 100 tentacle one;)
		idState = [for (i in 0...maxTouchpoints) false];
		
		super();
	}
	
	public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void {
		
		moved = false;
		lastX = lastY = 0.0;
		//touchpoint = cast getObjectsUnderPoint(new Point(x, y))[0];
		var obj = getObjectsUnderPoint(new Point(x, y))[0];
		if (obj != null) {
			if (Type.getClassName(Type.getClass(obj)) == "TouchPoint") touchpoint = cast obj;
			else if (Type.getClassName(Type.getClass(obj)) == "openfl.text.TextField") touchpoint = cast obj.parent;
		}
		if (touchpoint == null) {
			touchpoint = addTouchPoint(x, y);
			touchStart( new Touch(x/window.width, y/window.height, touchpoint.id, 0.0, 0.0, 1.0, device) );
		}
	}
	
	public function onMouseMove (window:Window, x:Float, y:Float):Void {

		if (touchpoint != null) {
			moved = true;
			touchpoint.x = lastX = x;
			touchpoint.y = lastY = y;
			touchMove( new Touch(x/window.width, y/window.height, touchpoint.id, (x-lastX)/window.width, (y-lastY)/window.height, 1.0, device) );
		}
		
	}
	
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (moved == false) {
			touchEnd( new Touch(x/window.width, y/window.height, touchpoint.id, (x-lastX)/window.width, (y-lastY)/window.height, 1.0, device) );
			delTouchPoint(touchpoint);
		}
		touchpoint = null;
		
	}

	/*
	 * Adds a new Touchpoint
	 * 
	 */ 	
	function addTouchPoint(x:Float, y:Float):TouchPoint
	{
		var tp = new TouchPoint (x, y, idState.indexOf(false), radius);
		addChild (tp);
		
		idState[tp.id] = true;
		
		return (tp);
	}
	
	/*
	 * Delete existing Touchpoint
	 * 
	 */ 	
	function delTouchPoint(touchpoint:TouchPoint)
	{
		idState[touchpoint.id] = false;
		removeChild (touchpoint);
		touchpoint = null;
	}

}



/**
 * Helper Class to store touchpoint id and delta positions
 * 
 */

class TouchPoint extends Sprite
{
	public var id:Int;
	
	public function new (x:Float, y:Float, id:Int, radius:Float) {

		super ();

		this.id = id;
		this.x = x;
		this.y = y;
		
		//cacheAsBitmap = true;
				
		var idText = new TextField();
		idText.selectable = false;
		idText.autoSize = TextFieldAutoSize.CENTER;
		idText.multiline = false;
		idText.width = idText.height = 1;
		idText.scaleX = idText.scaleY = 1.5;
		idText.textColor = 0x555555;
		idText.text = '$id';
		idText.x = - radius * 0.2;
		idText.y = - radius * 0.9;
		addChild (idText);

		//graphics.beginFill (0xBFFF00);
		graphics.lineStyle(1, 0xE03010);
		
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(radius * 2, radius * 2, 0, 0, 0);
		graphics.lineGradientStyle(GradientType.LINEAR, [0xFF0000, 0x00FF00, 0x0000FF, 0xFF0000], [1, 1, 1, 1], [0, 96, 192, 255], matrix);
		graphics.drawCircle(0, 0, radius);
		
		matrix = new Matrix();
		matrix.createGradientBox(radius * 2, radius * 2, Math.PI/2, 0, 0);
		graphics.lineGradientStyle(GradientType.LINEAR, [0xFF0000, 0x00FF00, 0x0000FF, 0xFF0000], [0.5, 0.5, 0.5, 0.5], [0, 96, 192, 255], matrix);
		graphics.drawCircle(0, 0, radius);
		
	}
	
}
