
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

class VideoPlayer{  
  var index:Int = 0;  
  var count:Int;
  var parent:Sprite;
  var totalTime:Float;
  var leftTime:Float = 0;
  var timeRate:Float = 50;
  var timer:Timer;  
  var stopped = true;
  var tilesheet:Tilesheet;
  var width:Int;
  var x:Int;
  var y:Int;
  var bitmap: BitmapData;
  var cols:Int;
  public var pause:Bool;
  
  var updateView:(Int->Void);
  
  public var onEnd:(Void->Void);
  
  public function new (parent:Sprite, x:Int, y:Int, width:Int, height:Int, totalTime:Int, rows: Int, cols: Int, count: Int, bitmap: BitmapData) {
    this.parent = parent;
    this.count = count;
    this.x = x;
    this.y = y;
    this.width = width;
    this.totalTime = totalTime;
    this.tilesheet = new Tilesheet(bitmap);
    this.bitmap = bitmap;
    this.cols = cols;
    
    var k : Int = 0;
    var rowHeight = bitmap.height/rows;
    var colWidth = bitmap.width/cols;
    for(i in 0...rows){
      for(j in 0...cols){
        if(k < count){
          tilesheet.addTileRect (new Rectangle (j*colWidth, i*rowHeight, colWidth, rowHeight));
          k++;
        }
      }
    }
  }
  
  public function reset(){
    index = 0;
    leftTime=0;
    pause=false;
    stopped=true;
  }
  
  public function stop(){
    index = 0;
    leftTime=0;
    pause=true;
    stopped=true;
  }
  
  public function start(){
    var _x = Std.parseFloat(""+x), _y = Std.parseFloat(""+y);
    var scale = cols * width/bitmap.width;
    if(timer != null) timer.stop();
    timer = new Timer(Std.int(timeRate));
    timer.run = function(){
      if(pause) return;
      
      if(index>=count-1) {
        if(onEnd != null){
          onEnd();
        }
        return;
      }
      
      index = index+1;
      
      
      if(leftTime >= totalTime){
        trace(2);
      
        timer.stop();
        if(onEnd != null){
          onEnd();
        }
      }
      
      
      leftTime+=timeRate;
            
      tilesheet.drawTiles (parent.graphics, [_x, _y, Std.parseFloat(""+index), scale], true, Tilesheet.TILE_SCALE);
    };
  }
  
  public function destroy(){
    timer.stop();
    tilesheet = null;
    timer = null;
    parent.graphics.clear();
  }
}
