package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.text.TextField;
import openfl.geom.Rectangle;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import motion.Actuate;
import motion.easing.Quad;
import haxe.Timer;

class MyTextField extends TextField {
  public function new(){
    super();
    
    #if flash
      embedFonts = true;
    #end
    
    selectable = false;
  }
}
