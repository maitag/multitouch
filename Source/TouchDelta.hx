package;

import lime.ui.Touch;

/**
 * Helper Class to store Touch values in pixels
 * 
 */
class TouchDelta extends Touch
{
	public var lastX:Float;
	public var lastY:Float;
	
	public var deltaX(get, null):Float = 0;
	public var deltaY(get, null):Float = 0;
	
	public function get_deltaX():Float { return x - lastX; }
	public function get_deltaY():Float { return y - lastY; }
	
	
	public function new (touch:Touch) {
		lastX = touch.x;
		lastY = touch.y;
		super(touch.x, touch.y, touch.id, touch.dx, touch.dy, touch.pressure, touch.device);
	}
	
	public function update (touch:Touch) {
		//lastX = touch.x;
		//lastY = touch.y;
		x = touch.x;
		y = touch.y;
	}
	
}