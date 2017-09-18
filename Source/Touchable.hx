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
		
		// TODO: serialize SimpleList-append to prevent race conditions ;)
		Touchable.fromIdTouch.set( touch.id, touchpoints.append(touch) );
		
		trace(touchpoints.length );
		if (touchpoints.length > tp_max) {
			touchpoints.unlink(touchpoints.first);
			startX = x - touchpoints.first.node.dx;
			startY = y - touchpoints.first.node.dy;
		}

		if (touchpoints.length == 1) {
			startX = x;
			startY = y;
		}
				
	}

	public function onTouchMove (touch:Touch):Void {
		
		Touchable.fromIdTouch[touch.id].node = touch;
		
		update(); // or call from onUpdate Event!
		
	}

	public function onTouchEnd (touch:Touch):Void {
		
		if ( touch.id == touchpoints.first.node.id ) {
			
			// TODO: serialize SimpleList-unlink to prevent race conditions ;)
			touchpoints.unlink(touchpoints.first);

			if (touchpoints.first != null)
			{
				startX = x - touchpoints.first.node.dx;
				startY = y - touchpoints.first.node.dy;		
			}
		}
		else {
			// TODO: serialize SimpleList-unlink to prevent race conditions ;)
			touchpoints.unlink(Touchable.fromIdTouch[touch.id]);
		}
		
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

}
