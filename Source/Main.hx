package;

import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import lime.ui.Touch;
import openfl.text.TextField;

import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.geom.Point;

class Main extends Application {
	
	var touchables:Sprite;
	var touchEmulation:TouchEmulation;
	var touchEmulationEnabled:Bool = false;
	
	public function new () {
		
		super ();		
	}
	
	
	public override function onWindowCreate():Void {
		
		#if !flash
		
		var stage = new Stage (window, 0xFFFFFF);
		
		var helpText = new TextField();
		helpText.width = window.width;
		helpText.height = 100;
		helpText.scaleX = helpText.scaleY = 2;
		helpText.text = 'press "m" to start touch-emulation with mouse:\n - add/drag touchpoint with mouse+drag\n - remove touchpoint with single click';
		stage.addChild (helpText);
		
		touchables = new Sprite ();
		stage.addChild (touchables);
		
		touchables.addChild ( new Touchable (window, 0, 100, 350, 400, 0xEE9910) );
		touchables.addChild ( new Touchable (window, 300, 250, 300, 300, 0x1419ab) );
		touchables.addChild ( new Touchable (window, 100, 480, 450, 350, 0x14ab11) );
				
		touchEmulation = new TouchEmulation(onTouchStart, onTouchMove, onTouchEnd, Touchable.maxTouchpoints);
		stage.addChild(touchEmulation);

		addModule (stage);
		
		#end
	}
	
	/*
	 * forwards global mouse-events to touchEmulation
	 * 
	 */
	public override function onMouseDown (x:Float, y:Float, button:Int):Void {
		//trace('onMouseDown: x=${x}, y=${y}, button=${button}'); 
		if (touchEmulationEnabled) touchEmulation.onMouseDown(window, x, y, button);		
	}
	
	public override function onMouseMove (x:Float, y:Float):Void {
		//trace('onMouseMove: x=${x}, y=${y}'); 
		if (touchEmulationEnabled) touchEmulation.onMouseMove(window, x, y);
	}
	
	public override function onMouseUp (x:Float, y:Float, button:Int):Void {
		//trace('onMouseUp: x=${x}, y=${y}, button=${button}');
		if (touchEmulationEnabled) touchEmulation.onMouseUp(window, x, y, button);
	}
	
	/*
	 * global touch-events
	 * 
	 */
	public override function onTouchStart (touch:Touch):Void {
		
		trace('+onTouchStart: device=${touch.device}, id=${touch.id}, x=${touch.x}, y=${touch.y}, dx=${touch.dx}, dy=${touch.dy}');
		
		var picked = touchables.getObjectsUnderPoint(new Point(touch.x * window.width, touch.y * window.height));
		
		var touched:Touchable = cast picked[picked.length-1];
		if (touched != null) {
			Touchable.fromId[touch.id] = touched;
			touched.onTouchStart(touch);
		}
		
	}
		
	public override function onTouchMove (touch:Touch):Void {
		
		//trace(' onTouchMove: device=${touch.device}, id=${touch.id}, x=${touch.x}, y=${touch.y}, dx=${touch.dx}, dy=${touch.dy}');
		
		var touched:Touchable = Touchable.fromId[touch.id];
		if (touched != null) {
			touched.onTouchMove(touch);
		}
		
	}
	
	public override function onTouchEnd (touch:Touch):Void {
		
		trace('-onTouchEnd: device=${touch.device}, id=${touch.id}, x=${touch.x}, y=${touch.y}, dx=${touch.dx}, dy=${touch.dy}');
		
		var touched:Touchable = Touchable.fromId[touch.id];
		if (touched != null) {
			Touchable.fromId[touch.id] = null;
			touched.onTouchEnd(touch);
		}

	}
	
	public override function onKeyUp (key:KeyCode, modifier:KeyModifier):Void {
		
		switch (key) {
			
			case KeyCode.M: touchEmulationEnabled = true;
			default:
			
		};
		
	}	
}



