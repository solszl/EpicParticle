package com.shrimp.particle
{
	import flash.geom.ColorTransform;

	/**
	 * 颜色
	 * @author Sol
	 *
	 */	
	public class ColorARGB
	{
		private static const ct:ColorTransform = new ColorTransform();

		public var red:Number;
		public var green:Number;
		public var blue:Number;
		public var alpha:Number;

		public function ColorARGB(red:Number=0, green:Number=0, blue:Number=0, alpha:Number=0)
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
		}

		public function toRGB():uint
		{
			var r:Number = red;   if (r < 0.0) r = 0.0; else if (r > 1.0) r = 1.0;
			var g:Number = green; if (g < 0.0) g = 0.0; else if (g > 1.0) g = 1.0;
			var b:Number = blue;  if (b < 0.0) b = 0.0; else if (b > 1.0) b = 1.0;

			return int(r * 255) << 16 | int(g * 255) << 8 | int(b * 255);
		}

		public function toColorTransform():ColorTransform
		{
			ct.redMultiplier = red;
			ct.greenMultiplier = green;
			ct.blueMultiplier = blue;
			ct.alphaMultiplier = alpha;
			return ct;
		}

		public function add(color:ColorARGB):ColorARGB
		{
			var c:ColorARGB = new ColorARGB(red,green,blue,alpha);
			c.red += getRangeWave(color.red);
			c.green += getRangeWave(color.green);
			c.blue += getRangeWave(color.blue);
			c.alpha += getRangeWave(color.alpha);
			return c;
		}

		public function sub(color:ColorARGB):ColorARGB
		{
			var c:ColorARGB = new ColorARGB(red,green,blue,alpha);
			c.red -=  color.red;
			c.green -= color.green;
			c.blue -= color.blue;
			c.alpha -= color.alpha;
			return c;
		}

		public function mul(num:Number):ColorARGB
		{
			var c:ColorARGB = new ColorARGB(red,green,blue,alpha);
			c.red *= num;
			c.green *= num;
			c.green *= num;
			c.alpha *= num;
			return c;
		}

		public function div(num:Number):ColorARGB
		{
			var c:ColorARGB = new ColorARGB(red,green,blue,alpha);
			c.red /= num;
			c.green /= num;
			c.blue /= num;
			c.alpha /= num;
			return c;
		}

		public function getRangeWave(v:Number):Number
		{
			return v * (Math.random() * 2.0 - 1.0);
		}
	}
}

