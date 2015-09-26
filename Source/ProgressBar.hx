import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.text.TextField;
import openfl.geom.Rectangle;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import openfl.Assets;
import flash.display.Sprite;
import gif.AnimatedGif;
import haxe.io.Bytes;

import motion.Actuate;
import motion.easing.Quad;

import haxe.Timer;
import haxe.Utf8;

class ProgressBar{
  var gradient:Bitmap;
  var gradient_ob:Bitmap;
  var parent:Sprite;
  var totalTime:Float;
  var leftTime:Float = 0;
  var timeRate:Float = 150;
  var timer:Timer;      
  var updateProgressBar:(Float->Void);
  var stopped = true;
  
  public var onEnd:(Void->Void);
  
  public function new (parent:Sprite, x:Int, y:Int, width:Int, time:Int) {
    this.parent = parent;
    this.totalTime = time;
    
    gradient = addBitmap("gradient.png");
    gradient.x = x;
    gradient.y = y;
    gradient.width = width;
    
    gradient_ob = addBitmap("gradient_ob.png");
    gradient_ob.x = x;
    gradient_ob.y = y;
    gradient_ob.width = width;
    
    updateProgressBar = function(percent:Float){
      gradient_ob.width = Math.round(width*(1-percent));
      gradient_ob.x = x + Math.round(width*percent);
    };
  }
  
  public function reset(){
    if(updateProgressBar!=null) updateProgressBar(0);
    leftTime = 0;
  }
  
  public function start(){
    timer = new Timer(Std.int(timeRate));
    timer.run = function(){
      if(leftTime >= totalTime){
        timer.stop();
        if(onEnd != null){
          onEnd();
        }
      }
      
      leftTime+=timeRate;
      updateProgressBar(leftTime/totalTime);
    };
  }
  
  private function addBitmap(fn:String):Bitmap{
      var bitmapData = Assets.getBitmapData ("assets/"+fn);
      var bitmap = new Bitmap (bitmapData);
      parent.addChild (bitmap);
      return bitmap;
  }
  
  public function destroy(){
    timer.stop();
    timer = null;
    parent.removeChild(gradient_ob);
    parent.removeChild(gradient);
  }
}
