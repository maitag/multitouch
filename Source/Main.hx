package;

import lime.app.Application;
import lime.app.Config;
import lime.graphics.RenderContext;
import lime.ui.Window;
import lime.ui.Touch;

import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.geom.Point;

class Main extends Application {
	
	var touchables:Sprite;
	var touchEmulation:TouchEmulation;	
	
	public function new () {
		
		super ();		
	}
	
	
	public override function create (config:Config):Void {
		
		super.create (config);
		
		
		var stage = new Stage (window, 0xFFFFFF);
		touchables = new Sprite ();
		stage.addChild (touchables);
		
		touchables.addChild ( new Touchable (100, 100, 200, 300, 0xEE9910) );
		touchables.addChild ( new Touchable (350, 100, 200, 200, 0x1419ab) );
				
		touchEmulation = new TouchEmulation(onTouchStart, onTouchMove, onTouchEnd, Touchable.maxTouchpoints);
		stage.addChild(touchEmulation);

		addModule (stage);
	}
	
	/*
	 * forwards global mouse-events to touchEmulation
	 * 
	 */
	public override function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void {
		touchEmulation.onMouseDown(window, x, y, button);		
	}
	
	public override function onMouseMove (window:Window, x:Float, y:Float):Void {
		touchEmulation.onMouseMove(window, x, y);
	}
	
	public override function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		touchEmulation.onMouseUp(window, x, y, button);
	}
	
	/*
	 * global touch-events
	 * 
	 */
	public override function onTouchStart (touch:Touch):Void {
		
		trace('onTouchStart: device=${touch.device}, id=${touch.id}, dx=${touch.dx}, dy=${touch.dy}');

		var touched:Touchable = cast touchables.getObjectsUnderPoint(new Point(touch.x, touch.y))[0];
		if (touched != null) {
			Touchable.fromId[touch.id] = touched;
			touched.onTouchStart(touch);
		}
		
	}
		
	public override function onTouchMove (touch:Touch):Void {
		
		//trace('onTouchMove: device=${touch.device}, id=${touch.id}, dx=${touch.dx}, dy=${touch.dy}');
		
		var touched:Touchable = Touchable.fromId[touch.id];
		if (touched != null) {
			touched.onTouchMove(touch);
		}
		
	}
	
	public override function onTouchEnd (touch:Touch):Void {
		
		trace('onTouchEnd: device=${touch.device}, id=${touch.id}, dx=${touch.dx}, dy=${touch.dy}');
		
		var touched:Touchable = Touchable.fromId[touch.id];
		if (touched != null) {
			Touchable.fromId[touch.id] = null;
			touched.onTouchEnd(touch);
		}
		
	}
	
	
}



