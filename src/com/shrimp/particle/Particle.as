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
		/**	混合模式，默认为add*/
		public var blendMode:String = BlendMode.ADD;
		/**	模糊滤镜*/
		public var blur:BlurFilter
		/** 粒子是否还活着*/
		private var _isLive:Boolean;
		public var alpha:Number;
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

		public var x:Number;
		public var y:Number;
		public var color:uint;

		private var bmd:BitmapData;

		public var display:Bitmap;
		public function Particle(texture:BitmapData = null)
		{
			this.bmd = texture;

			blur = new BlurFilter(4,4);
			x = y = rotation = currentTime = 0.0;
			totalTime = alpha = scale = 1.0;
			color = 0xffffff;
			colorARGB = new ColorARGB();
			colorDelta = new ColorARGB();
			display= new Bitmap(null);
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
			this.bmd = value;
		}

		public function get texture():BitmapData
		{
			return this.bmd;
		}

		private static const m:Matrix = new Matrix();
		public function update():void
		{
			//			this.bmd.lock();
			//			// 颜色
			//			//			//			bmd.draw(bmd,m,colorARGB.toColorTransform(),BlendMode.HARDLIGHT);
			//			//			//			bmd.applyFilter(bmd,bmd.rect,new Point(),blur);
			//
			//			//			bmd.colorTransform(bmd.rect,colorARGB.toColorTransform(colorDelta));
			//			m.identity();
			//			m.scale(scale,scale);
			//			bmd.draw(bmd,m);
			//			this.bmd.unlock();
			
			display.bitmapData = this.bmd;
			display.rotation = rotation;
			display.scaleX = scale;
			display.scaleY = scale;
			display.transform.colorTransform = colorARGB.toColorTransform();
			display.blendMode = BlendMode.ADD

		}

		public function rad2deg(rad:Number):Number
		{
			return rad / Math.PI * 180.0;            
		}

		/** Converts an angle from degrees into radians. */
		public function deg2rad(deg:Number):Number
		{
			return deg / 180.0 * Math.PI;   
		}
	}
}

