﻿package{
	
	import flash.display.MovieClip;
	
	import flash.events.Event;

	import flash.geom.Point;
	
	public class FloatingDamageFader extends MovieClip {
		
		public var widget:FloatingDamageWidget;

		public var damageReceived: uint = 0;
		public var screenData: Array;
		public var worldData: Array;
		public var isBuff: Boolean;
		//public var canFollow: Boolean = true;
		
		private var frameCount: uint = 0;
		private var step: Number;
		private var speed: Number;
		private var direction: int;
		private var fallDist: Number;
		private var codeObj: Object;
		private var graveFactor: Number = 0.1;
		
		private var fadeOut: Boolean = false;

		public function FloatingDamageFader()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}		
		
		private function addedToStageHandler(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			codeObj = stage.getChildAt(0)["f4se"].plugins.FloatingDamage;

			step = range(2.5, 4, false);
			fallDist = range(80, 120, false);
			speed = range(1, 4, true);
			direction = wave;
			
			var screenPos: Point = parent.globalToLocal(new Point(stage.stageWidth * screenData[0], stage.stageHeight * screenData[1]));
			this.x = screenPos.x;
			this.y = screenPos.y;
			
			gotoAndPlay("fadeIn");
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}		
		
		public function get damage(): uint 
		{
			return damageReceived;
		}
		
		public function set damage(val: uint):void 
		{
			damageReceived = val;
			widget.damage = val;
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			UpdateSelf();
		}
		
		protected function OnFadeOutComplete()
        {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			parent.removeChild(this);
        }
		
		protected function OnFadeInComplete()
        {

        }

		protected function OnFadeOutStart()
        {

        }
		
		private function UpdateSelf(): void
		{
			++frameCount;
			var newScreenPosArr: Array = null;
			var newScreenPos: Point = null;
			var offsetY: Number = 0;
			if(isBuff)
			{
				newScreenPosArr = codeObj.WorldtoScreen(worldData[0], worldData[1], worldData[2]);
				newScreenPos = parent.globalToLocal(new Point(stage.stageWidth * newScreenPosArr[0], stage.stageHeight * newScreenPosArr[1]));
				this.x = newScreenPos.x;
				offsetY = 3 * frameCount;

				if(!fadeOut && offsetY > fallDist)
				{
					fadeOut = true;
					gotoAndPlay("fadeOut");
				}
				this.y = newScreenPos.y - offsetY;					
			}
			else
			{
				newScreenPosArr = codeObj.WorldtoScreen(worldData[0], worldData[1], worldData[2]);
				newScreenPos = parent.globalToLocal(new Point(stage.stageWidth * newScreenPosArr[0], stage.stageHeight * newScreenPosArr[1]));
				this.x = newScreenPos.x + step * frameCount * direction;
				offsetY = graveFactor * frameCount * frameCount - speed * frameCount;

				if(!fadeOut && offsetY > fallDist)
				{
					fadeOut = true;
					gotoAndPlay("fadeOut");
				}
				this.y = newScreenPos.y + offsetY;			
			}
		}
		
		public static function get boolean():Boolean
		{
			return Math.random() < 0.5;
		}
		
		public static function get wave():int
		{
			return boolean ? 1 : -1;
		}

		public static function range(num1:Number,num2:Number,isInt:Boolean = true):Number
		{
			var num:Number = Math.random() * Number(num2 - num1) + num1;
			if (isInt)
			{
				num = Math.floor(num);
			}
			return num;
		}
	}	
}
