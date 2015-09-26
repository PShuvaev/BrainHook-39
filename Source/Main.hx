package;


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

using Lambda;

class Main extends Sprite {
  private var codeTextField:TextField = new TextField();
  private var codeTextField2:TextField = new TextField();
  private var codeTxt = "hello, world!";
  private var codeTxtPos = 1;
  var state : State;
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
  }
  
  private function showWinPage(){
    var bitmap = addBitmap("win.jpg");
    bitmap.width = stage.stageWidth;
    bitmap.height = stage.stageHeight;
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

class Splash1 extends Sprite {
  var scoreFormat:TextFormat;
  var newGameBtn = new TextField();
  var exitBtn = new TextField();

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
      
      exitBtn.text = "Exit game";
      exitBtn.defaultTextFormat = scoreFormat;
      exitBtn.x = 450;
      exitBtn.y = 50;
      exitBtn.width = 300;
      addChild(exitBtn);
      exitBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent){
        flash.system.System.exit(0);
      });    
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

class Game1 extends Sprite{
  var totalTimeProgressBar:ProgressBar;
  
  private var codeTextField:TextField = new TextField();
  private var coffeeLevel:TextField = new TextField();
  private var codeTxt = "hello, world!";
  private var codeTxtPos = 0;
  private var finished = false;  
  private var failGame:Void->Void;
  private var winGame:Void->Void;
  

  var scoreFormat:TextFormat = new TextFormat("Verdana", 36, 0x4b4b4b, true);
  var scoreFormat2:TextFormat = new TextFormat("Verdana", 36, 0x00bb5b, true);

  public function new (failGame:Void->Void, winGame:Void->Void) {
    super();
    this.failGame = failGame;
    this.winGame = winGame;
    
    addEventListener(Event.ADDED_TO_STAGE, function(e){
        
      totalTimeProgressBar = new ProgressBar(this, 10, 10, stage.stageWidth-20, 50*1000);
      totalTimeProgressBar.onEnd = function(){
        if(!finished){
          failGame();
        }
      };
      totalTimeProgressBar.start();
      
      
      addChild(codeTextField);
      codeTextField.width = stage.stageWidth;
      codeTextField.height = 50;
      codeTextField.x = stage.stageWidth-20;
      codeTextField.y = stage.stageWidth/2;
      codeTextField.defaultTextFormat = scoreFormat;
      codeTextField.selectable = false;
      codeTextField.text = codeTxt;
      
      
      var coffeeLevelFont = Assets.getFont ("assets/FreebooterUpdated.ttf");
      var coffeeLevelFormat = new TextFormat(coffeeLevelFont.fontName, 40, 0xa86540, true);
    
      addChild(coffeeLevel);
      coffeeLevel.width = stage.stageWidth;
      coffeeLevel.x = 200;
      coffeeLevel.y = 0;
      coffeeLevel.defaultTextFormat = coffeeLevelFormat;
      coffeeLevel.selectable = false;
      coffeeLevel.text = "Level of coffee in the blood";
      
      
      var textMoveTimerRate = 50;
      var textMoveTimer = new Timer(textMoveTimerRate);
      textMoveTimer.run = function(){
        codeTextField.x = codeTextField.x-1;
      };
      
      stage.addEventListener(KeyboardEvent.KEY_UP, keyDown);
          
          
      var vpData = Assets.getBitmapData ("assets/work.jpg");
      var drinkData = Assets.getBitmapData ("assets/drink.jpg");
      
      var vp = new VideoPlayer(this, 0, 0, stage.stageWidth, stage.stageHeight, 30*1000, 11, 11, 109, vpData);
      vp.onEnd = function(){
        if(!finished){
          failGame();
        }
      };
      vp.start();
      
      
      var coffeeBitmap = addBitmap("coffee.png");
      coffeeBitmap.x = 50;
      coffeeBitmap.y = 650;
      
      // выпрыгивает чашка с кофе
      var coffeeHeight = coffeeBitmap.height;
      var coffeeWidth = coffeeBitmap.width;
      Actuate.tween (coffeeBitmap, 0.8, { y: 450-100, height: coffeeHeight*0.6, width: coffeeWidth*0.8 }, false).ease (Quad.easeInOut)
        .onComplete(function(){
          Actuate.tween (coffeeBitmap, 0.4, { y: 450, height: coffeeHeight, width: coffeeWidth }, false).ease (Quad.easeInOut);
        });
      
      coffeeBitmap.addEventListener( MouseEvent.CLICK, function(arg){
        var coffeeWidth = coffeeBitmap.width;
        var coffeeHeight = coffeeBitmap.height;
        
        // чашка увеличивается при нажатии
        Actuate.tween (coffeeBitmap, 0.2, { height: coffeeHeight*1.1, width: coffeeWidth*1.1 }, false).ease (Quad.easeInOut)
          .onComplete(function(){
            Actuate.tween (coffeeBitmap, 0.2, { height: coffeeHeight, width: coffeeWidth }, false).ease (Quad.easeInOut);
          });
          
          vp.stop();
          
          var drinkPl = new VideoPlayer(this, 0, 0, stage.stageWidth, stage.stageHeight, 3*1000, 7, 7, 47, drinkData);
          drinkPl.onEnd = function(){
            vp.start();
          };
          
          drinkPl.start();
      });    
    
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
  
  
  private function keyDown(event:KeyboardEvent):Void {
    /*switch( state ) {
        case Intro: {};
    }*/

  
    if(codeTxtPos < codeTxt.length){
        if(
          codeTxt.toUpperCase().charCodeAt(codeTxtPos) == event.keyCode){
          codeTxtPos++;
        }else{
          codeTxtPos=0;
        }
      codeTextField.setTextFormat(scoreFormat);
      codeTextField.setTextFormat(scoreFormat2, 0, codeTxtPos);
    } 
    
    if(codeTxtPos >= codeTxt.length){
      // win!
      winGame();
      
      totalTimeProgressBar.destroy();
    }
  }
}


enum State {
  Intro;
  AnimationToGame1(step : Int);
  Game1_Fail;
  Game1_Win;
}
