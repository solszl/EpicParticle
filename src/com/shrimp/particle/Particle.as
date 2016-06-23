package com.shrimp.particle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 *
	 * @author 振亮
	 *
	 */	
	public class Particle
	{
		/**	粒子颜色*/
		public var colorARGB:ColorARGB;
		/**	粒子颜色变化量*/
		public var colorDelta:ColorARGB;
		/**	粒子当前生命值*/
		public var currentTime:Number;
		/**	粒子总时长*/
		public var totalTime:Number;
		/** 粒子是否还活着*/
		private var _isLive:Boolean;
		public var scale:Number;
		public var startX:Number, startY:Number;
		public var velocityX:Number, velocityY:Number;
		public var radialAcceleration:Number;
		public var tangentialAcceleration:Number;
		public var emitRadius:Number, emitRadiusDelta:Number;
		public var emitRotation:Number, emitRotationDelta:Number;
		public var rotationDelta:Number;
		public var scaleDelta:Number;
		public var rotation:Number;

		private var bmd:BitmapData;
		public var display:Bitmap;

		public function Particle(texture:BitmapData = null)
		{
			rotation = currentTime = 0.0;
			totalTime = scale = 1.0;
			colorARGB = new ColorARGB();
			colorDelta = new ColorARGB();
			display= new Bitmap(texture);
		}

		/**
		 * 判断当前粒子是否还活着
		 */		
		public function get isLive():Boolean
		{
			return this.currentTime < this.totalTime;
		}

		public function set texture(value:BitmapData):void
		{
			display.bitmapData = value;
		}

		public function get texture():BitmapData
		{
			return display.bitmapData;
		}

		public function update():void
		{
			display.rotation = rotation;
			display.scaleX = scale;
			display.scaleY = scale;
			display.transform.colorTransform = colorARGB.toColorTransform();
			display.blendMode = BlendMode.ADD
		}
	}
}

