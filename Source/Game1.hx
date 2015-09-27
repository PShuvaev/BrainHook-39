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

class Game1 extends Sprite{
  var totalTimeProgressBar:ProgressBar;
  
  private var codeTextField:TextField = new MyTextField();
  private var coffeeLevel:TextField = new MyTextField();
  private var codeTxt = "private var codeTextField is TextField eq new TextField";
  private var codeTxtPos = 0;
  private var finished = false;  
  private var failGame:Void->Void;
  private var winGame:Void->Void;
  private var textMoveTimer:Timer;
  private var mainVideoPlayer:VideoPlayer;
  
  var coffeeLevelFormat: TextFormat;
  
  var patternTxtFormat:TextFormat = new TextFormat("Verdana", 56, 0xff0000, true);
  var enteredTxtFormat:TextFormat = new TextFormat("Verdana", 56, 0xff0000, true);
  
  
  var gameEnded = false;
  private function endGameWith(f:Void->Void):Void->Void{
      return function(){
        if(gameEnded) return;
        gameEnded = true;
        stage.removeEventListener(KeyboardEvent.KEY_UP, keyDown);
        if(textMoveTimer!=null) textMoveTimer.stop();
        if(mainVideoPlayer!=null) mainVideoPlayer.destroy();
        f();
      };
  }

  public function new (_failGame:Void->Void, _winGame:Void->Void) {
    super();
    this.failGame = endGameWith(_failGame);
    this.winGame = endGameWith(_winGame);
    
    addEventListener(Event.ADDED_TO_STAGE, function(e){
        
      totalTimeProgressBar = new ProgressBar(this, 10, 10, stage.stageWidth-20, 15*1000);
      totalTimeProgressBar.onEnd = function(){
        if(!finished){
          failGame();
        }
      };
      totalTimeProgressBar.start();
      
      
      addChild(codeTextField);
      codeTextField.width = stage.stageWidth;
      codeTextField.height = 100;
      codeTextField.x = stage.stageWidth-20;
      codeTextField.y = stage.stageWidth/2-50;
      codeTextField.defaultTextFormat = patternTxtFormat;
      codeTextField.selectable = false;
      codeTextField.text = codeTxt;
      
      var coffeeLevelFont = Assets.getFont ("assets/FreebooterUpdated.ttf");
      coffeeLevelFormat = new TextFormat(coffeeLevelFont.fontName, 40, 0xa86540, true);
    
      addChild(coffeeLevel);
      coffeeLevel.width = stage.stageWidth;
      coffeeLevel.x = 200;
      coffeeLevel.y = 0;
      coffeeLevel.defaultTextFormat = coffeeLevelFormat;
      coffeeLevel.selectable = false;
      coffeeLevel.text = "Level of coffee in the blood";      
      
      var textMoveTimerRate = 50;
      textMoveTimer = new Timer(textMoveTimerRate);
      textMoveTimer.run = function(){
        codeTextField.x = codeTextField.x-2;
        codeTextField.width = codeTextField.width+2;
      };
      
      stage.addEventListener(KeyboardEvent.KEY_UP, keyDown);
          
          
      var vpData = Assets.getBitmapData ("assets/work.jpg");
      var drinkData = Assets.getBitmapData ("assets/drink.jpg");
      
      mainVideoPlayer = new VideoPlayer(this, 0, 0, stage.stageWidth, stage.stageHeight, 15*1000, 13, 13, 166, vpData);
      mainVideoPlayer.onEnd = function(){
        if(!finished){
          failGame();
        }
      };
      mainVideoPlayer.start();
      
      
      var coffeeBitmap = addBitmap("coffee.png");
      coffeeBitmap.x = 50;
      coffeeBitmap.y = 650;
      
      // выпрыгивает чашка с кофе
      var coffeeHeight = coffeeBitmap.height;
      var coffeeWidth = coffeeBitmap.width;
      Actuate.tween (coffeeBitmap, 0.8, { y: 450-50, height: coffeeHeight*0.8, width: coffeeWidth*0.9 }, false).ease (Quad.easeInOut)
        .onComplete(function(){
          Actuate.tween (coffeeBitmap, 0.4, { y: 450, height: coffeeHeight, width: coffeeWidth }, false).ease (Quad.easeInOut);
        });
      
      var coffeeLock = false;
      
      coffeeBitmap.addEventListener( MouseEvent.CLICK, function(arg){
        if(coffeeLock) return;
        coffeeLock = true;
        
        totalTimeProgressBar.stopped = true;
        
        var coffeeWidth = coffeeBitmap.width;
        var coffeeHeight = coffeeBitmap.height;
        
        // чашка увеличивается при нажатии
        Actuate.tween (coffeeBitmap, 0.2, { height: coffeeHeight*1.1, width: coffeeWidth*1.1 }, false).ease (Quad.easeInOut)
          .onComplete(function(){
            Actuate.tween (coffeeBitmap, 0.2, { height: coffeeHeight, width: coffeeWidth }, false).ease (Quad.easeInOut);
          });
          
          mainVideoPlayer.stop();
          
          var drinkPl = new VideoPlayer(this, 0, 0, stage.stageWidth, stage.stageHeight, 5*1000, 7, 7, 47, drinkData);
          drinkPl.onEnd = function(){
            mainVideoPlayer.start();
            coffeeLock = false;
            totalTimeProgressBar.stopped = false;
            totalTimeProgressBar.reset();
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
  
  private function animateSymbolDeletion(ch: String){
    var tf = new MyTextField();
    tf.width = tf.height = 60;
    tf.defaultTextFormat = enteredTxtFormat;
    tf.text = ch;
    var sprite = new Sprite();
    sprite.x = codeTextField.x;
    sprite.y = codeTextField.y;
    sprite.addChild(tf);
    sprite.width = sprite.height = 60;
    addChild(sprite);

    
    Actuate.tween (sprite, 0.4, { y: sprite.y-250, x: sprite.x-250, width: 160, height: 160, alpha: 0 }, false).ease (Quad.easeInOut)
        .onComplete(function(){
          removeChild(sprite);
        });
  }
  
  private function keyDown(event:KeyboardEvent):Void {
    if(codeTxtPos < codeTxt.length){
        trace(codeTxt.toUpperCase().charCodeAt(codeTxtPos), event.keyCode);
        if(codeTxt.toUpperCase().charCodeAt(codeTxtPos) == event.keyCode){
          codeTxtPos++;
          animateSymbolDeletion(codeTxt.charAt(codeTxtPos));
        }else{
          //codeTxtPos=0;
        }
      codeTextField.text = codeTxt.substring(codeTxtPos, codeTxt.length);
      //codeTextField.setTextFormat(patternTxtFormat);
      //codeTextField.setTextFormat(enteredTxtFormat, 0, codeTxtPos);      
    } 
    
    if(codeTxtPos >= codeTxt.length){
      // win!
      winGame();      
      totalTimeProgressBar.destroy();
    }
  }
}
