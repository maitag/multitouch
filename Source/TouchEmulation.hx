package;

import lime.ui.Window;
import lime.ui.Touch;

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
		touchpoint = cast getObjectsUnderPoint(new Point(x, y))[0];
		if (touchpoint == null) {
			touchpoint = addTouchPoint(x, y);
			touchStart( new Touch(x, y, touchpoint.id, 0, 0, 1.0, 1) );
		}
		
	}
	
	public function onMouseMove (window:Window, x:Float, y:Float):Void {

		if (touchpoint != null) {
			moved = true;
			touchpoint.x = x;
			touchpoint.y = y;
			touchMove( new Touch(x, y, touchpoint.id, touchpoint.dx, touchpoint.dy, 1.0, -1) );
		}
		
	}
	
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (moved == false) {
			touchEnd( new Touch(x, y, touchpoint.id, touchpoint.dx, touchpoint.dy, 1.0, -1) );
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
		var tp = new TouchPoint (x, y, radius);
		addChild (tp);
		
		tp.id = idState.indexOf(false);
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
	public var startX:Float;
	public var startY:Float;
	
	public var dx(get, null):Float;
	function get_dx():Float { return x - startX; } // dx getter
	
	public var dy(get, null):Float;
	function get_dy():Float { return y - startY; } // dy getter
	
	public function new (x:Float, y:Float, radius:Float) {

		super ();

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
		
		this.x = startX = x;
		this.y = startY = y;
	}
	
}
