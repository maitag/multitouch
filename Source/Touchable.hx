package;

import haxe.ds.Vector;
import openfl.display.Sprite;
import lime.ui.Touch;
import lime.ui.Window;

/**
 * Helper Class to store touchpoints per Sprite into a linked List
 * 
 */

class Touchable extends Sprite
{
	public static var maxTouchpoints:Int = 100;
	public static var fromId = new Vector<Touchable>(maxTouchpoints);
	public static var fromIdTouch = new Vector<SimpleListNode<TouchDelta>>(maxTouchpoints);

	public var window:Window;
	
	public var xRel(get, set):Float;
	public function get_xRel():Float { return this.x / window.width; };
	public function set_xRel(x:Float):Float { return this.x = x * window.width; };
	
	public var yRel(get, set):Float;
	public function get_yRel():Float { return this.y / window.height; };
	public function set_yRel(y:Float):Float { return this.y = y * window.height; };
	
	var xRelStart:Float;
	var yRelStart:Float;

	var touchpoints:SimpleList<TouchDelta>;
	var tp_max:Int = 3;
	
	public function new (window:Window, x:Int, y:Int, width:Float, height:Float, color:Int ) {

		super ();
		
		this.window = window;
		
		touchpoints = new SimpleList<TouchDelta>();
		
		graphics.beginFill (color);
		graphics.drawRect (0, 0, width, height);
		
		this.x = x;
		this.y = y;
	}
	
	public function onTouchStart (touch:Touch):Void {
		
		Touchable.fromIdTouch.set( touch.id, touchpoints.append(new TouchDelta(touch)) );
		
		// ringbuffer (delete from start of list if maximum reached)
		if (touchpoints.length > tp_max) {
			Touchable.fromIdTouch[touchpoints.first.node.id] = null;
			touchpoints.unlink(touchpoints.first);
			xRelStart = xRel - touchpoints.first.node.deltaX;
			yRelStart = yRel - touchpoints.first.node.deltaY;
		}

		if (touchpoints.length == 1) {
			xRelStart = xRel;
			yRelStart = yRel;
		}
		debugTouchpointList(touchpoints);
	}

	public function onTouchMove (touch:Touch):Void {
		
		if (Touchable.fromIdTouch[touch.id] != null)
		{
			Touchable.fromIdTouch[touch.id].node.update(touch);
			update(); // or call from onUpdate Event!
		}
		
	}

	public function onTouchEnd (touch:Touch):Void {
		
		if (Touchable.fromIdTouch[touch.id] != null)
		{
			if ( touch.id == touchpoints.first.node.id && touchpoints.first.next != null ) {
				xRelStart = xRel - touchpoints.first.next.node.deltaX;
				yRelStart = yRel - touchpoints.first.next.node.deltaY;
			}
			touchpoints.unlink(Touchable.fromIdTouch[touch.id]);
		}
		
		debugTouchpointList(touchpoints);
	}
	
	
	public function update ():Void { // or called from onUpdate Event!
		
		// do more gesture-ops here:
		// (like scale and rotate with second touchpoint)
		
		switch ( touchpoints.length ) {
			case 0:
			//case 1:
			//case 2:
			default:
				xRel = xRelStart + touchpoints.first.node.deltaX;
				yRel = yRelStart + touchpoints.first.node.deltaY;
		}
		
	}

	public function debugTouchpointList(touchpoints:SimpleList<TouchDelta>) {
		var node = touchpoints.first;
		var out = "";
		while (node != null) {
			out += "->" + node.node.id;
			node = node.next;
		}
		trace(out);
	}
	
}
