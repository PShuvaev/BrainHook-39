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

class Main extends Sprite {
  private var codeTextField:TextField = new TextField();
  private var codeTextField2:TextField = new TextField();
  private var codeTxt = "hello, world!";
  private var codeTxtPos = 1;
  var currentPage: Sprite;
  
  var scoreFormat:TextFormat = new TextFormat("Verdana", 24, 0x4b4b4b, true);
  var scoreFormat2:TextFormat = new TextFormat("Verdana", 24, 0x00bb5b, true);
  
  private static function format(i:Int, num:Int):String{
    var s = ""+i;
    for(i in s.length...num){
      s = "0"+s;
    }
    return s;
  }
  
  public function startSplash1(){
    removeChildren();
    addChild(currentPage = new Splash1(startGame1));
  }
  
  public function startGame1(){
    if(currentPage != null) removeChild(currentPage);
    addChild(new Game1(showFailPage, showWinPage));
  }
  
  public function new () {
    super ();
    startSplash1();
  }
  
  private function showFailPage(){
    var bitmap = addBitmap("lose.jpg");
    bitmap.width = stage.stageWidth;
    bitmap.height = stage.stageHeight;
    
    Timer.delay(function(){
      startSplash1();
    }, 3000);
  }
  
  private function showWinPage(){
    var bitmap = addBitmap("win.jpg");
    bitmap.width = stage.stageWidth;
    bitmap.height = stage.stageHeight;
    
    Timer.delay(function(){
      startSplash1();
    }, 3000);
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
