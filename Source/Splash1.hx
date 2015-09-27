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

using Lambda;

class Splash1 extends Sprite {
  var scoreFormat:TextFormat;
  var newGameBtn = new MyTextField();
  var exitBtn = new MyTextField();

  public function new(startGame1:Void->Void){
    super();
    
    var font = Assets.getFont ("assets/FreebooterUpdated.ttf");
    scoreFormat = new TextFormat(font.fontName, 72, 0xaba05b, true);
    
    addEventListener(Event.ADDED_TO_STAGE, function(e){
      var centerX = stage.stageWidth / 2;
      var centerY = stage.stageHeight / 2;
      
      var back = addBitmap("back_1.jpg");
      
      newGameBtn.text = "New game";
      newGameBtn.defaultTextFormat = scoreFormat;
      newGameBtn.x = 100;
      newGameBtn.y = 50;
      newGameBtn.width = 300;
      addChild(newGameBtn);
      newGameBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent){
        Actuate.tween (newGameBtn, 0.4, { x: -500 }, false).ease (Quad.easeInOut);
        Actuate.tween (exitBtn, 0.4, { x: 2000 }, false).ease (Quad.easeInOut);
        
        Timer.delay(startGame1, 300);
      });
      addOnMouseAnumation(newGameBtn);
      
      exitBtn.text = "Exit game";
      exitBtn.defaultTextFormat = scoreFormat;
      exitBtn.x = 450;
      exitBtn.y = 50;
      exitBtn.width = 300;
      addChild(exitBtn);
      exitBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent){
        flash.system.System.exit(0);
      });
      addOnMouseAnumation(exitBtn);
    });
  }
  
  private function addOnMouseAnumation(field:TextField){
    var w = field.width, h = field.height;
    var sprite = new Sprite();
    addChild(sprite);
    
    sprite.x = field.x;
    sprite.y = field.y;
    sprite.addChild(field);
    field.x = field.y = 0;
    
    var w = sprite.width, h = sprite.height, _x = sprite.x, _y = sprite.y; 
    
    sprite.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent){
        Actuate.tween (sprite, 0.6, { width:w+4, height:h+4, x:_x-2, y:_y-2 }, false);
      });
    sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent){
        Actuate.tween (sprite, 0.6, { width:w-4, height:h-4, x:_x+2, y:_y+2 }, false);
      });
  }
  
  private function addBitmap(fn:String):Sprite{
      var bitmapData = Assets.getBitmapData ("assets/"+fn);
      var bitmap = new Bitmap (bitmapData);
      var sprite = new Sprite();
      sprite.addChild (bitmap);
      addChild(sprite);
      return sprite;
  }
}
