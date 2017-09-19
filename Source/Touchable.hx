package;

import haxe.ds.Vector;
import openfl.display.Sprite;
import lime.ui.Touch;

/**
 * Helper Class to store touchpoints per Sprite into a linked List
 * 
 */

class Touchable extends Sprite
{
	public static var maxTouchpoints:Int = 100;
	public static var fromId = new Vector<Touchable>(maxTouchpoints);
	public static var fromIdTouch = new Vector<SimpleListNode<Touch>>(maxTouchpoints);

	var startX:Float;
	var startY:Float;

	var touchpoints:SimpleList<Touch>;
	var tp_max:Int = 3;
	
	public function new (x:Int, y:Int, width:Float, height:Float, color:Int ) {

		super ();
		
		touchpoints = new SimpleList<Touch>();
		
		graphics.beginFill (color);
		graphics.drawRect (0, 0, width, height);
		
		this.x = x;
		this.y = y;
	}
	
	
	public function onTouchStart (touch:Touch):Void {
		
		Touchable.fromIdTouch.set( touch.id, touchpoints.append(touch) );
		
		// ringbuffer like (if more then max delete one from start of list)
		if (touchpoints.length > tp_max) {
			Touchable.fromIdTouch[touchpoints.first.node.id] = null;
			touchpoints.unlink(touchpoints.first);
			startX = x - touchpoints.first.node.dx;
			startY = y - touchpoints.first.node.dy;
		}

		if (touchpoints.length == 1) {
			startX = x;
			startY = y;
		}
		debugTouchpointList(touchpoints);
	}

	public function onTouchMove (touch:Touch):Void {
		
		if (Touchable.fromIdTouch[touch.id] != null)
		{
			Touchable.fromIdTouch[touch.id].node = touch;
			update(); // or call from onUpdate Event!
		}
		
	}

	public function onTouchEnd (touch:Touch):Void {
		
		if (Touchable.fromIdTouch[touch.id] != null)
		{
			if ( touch.id == touchpoints.first.node.id && touchpoints.first.next != null ) {
				startX = x - touchpoints.first.next.node.dx;
				startY = y - touchpoints.first.next.node.dy;
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
				x = startX + touchpoints.first.node.dx;
				y = startY + touchpoints.first.node.dy;
		}
		
	}

	public function debugTouchpointList(touchpoints:SimpleList<Touch>) {
		var node = touchpoints.first;
		var out = "";
		while (node != null) {
			out += "->" + node.node.id;
			node = node.next;
		}
		trace(out);
	}
	
}
