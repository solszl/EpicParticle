package com.shrimp.particle
{
	import com.shrimp.particle.interfaces.IAnimatable;
	import com.shrimp.particle.parser.XMLParser;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 *
	 * @author 振亮
	 *
	 */
	public class ParticleSystem extends Sprite implements IAnimatable
	{
		public static const EMITTER_TYPE_GRAVITY:int = 0;
		public static const EMITTER_TYPE_RADIAL:int = 1;

		// 最大粒子数
		public static const MAX_NUM_PARTICLES:int = 16383;

		/**	舞台*/
		private var s:Stage;

		/** 当前帧的时间戳*/
		private var frameTimestamp:Number = 0.0;

		/**	总时长*/
		private var totalTime:Number;

		/**	每秒发射的粒子数量*/
		public var emmitRate:int;

		/**	当前有多少个粒子*/
		private var numParticles:int;

		/**	粒子的纹理*/
		public var texture:BitmapData;

		/**	粒子集合*/
		private var particles:Vector.<Particle>;

		private var _p_capacity:int;

		private var t:Timer;

		public function ParticleSystem(stage:Stage, texture:BitmapData, config:String)
		{
			this.s = stage;
			this.texture = texture;
			this.particles = new Vector.<Particle>(0, false);
			this.emmitRate = 10;
			this.frameTime = 0.0;
			this.p_capacity = 128;
			this.p_emitX = this.p_emitY = 0.0;
			this.totalTime = 0.0

			var p:XMLParser = new XMLParser();
			p.parse(this, config);
//			this.t = new Timer(30);
//			this.t.addEventListener(TimerEvent.TIMER, onEnterFrameHandler);			
		}

		/**
		 * 初始化粒子
		 * @param p
		 *
		 */
		public function initParticle(p:Particle):void
		{
			p.texture = texture.clone();
			// 生命周期
			var lifespan:Number = p_lifeSpan + getRangeWave(p_lifeSpanV);
			var textureWidth:Number = texture ? texture.width : 1;

			p.currentTime = 0.0;
			p.totalTime = lifespan > 0.0 ? lifespan : 0.0;

			if(lifespan <= 0.0)
				return;

			var emitX:Number = this.p_emitX;
			var emitY:Number = this.p_emitY;

			//			var display:Bitmap = new Bitmap(p.texture);
			// 设置P的位置
			//			display.x = emitX + getRangeWave(this.p_emitXV);
			//			display.y = emitY + getRangeWave(this.p_emitYV);

			p.display.x = emitX + getRangeWave(this.p_emitXV);
			p.display.y = emitY + getRangeWave(this.p_emitYV);

			p.startX = emitX;
			p.startY = emitY;

			//角速度
			var angle:Number = this.p_emitAngle + getRangeWave(this.p_emitAngleV);
			var speed:Number = this.p_speed + getRangeWave(this.p_speedV);
			p.velocityX = speed * Math.cos(angle);
			p.velocityY = speed * Math.sin(angle);

			//半径
			var startRadius:Number = this.p_maxRadius + getRangeWave(this.p_maxRadiusV);
			var endRadius:Number = this.p_minRadius + getRangeWave(this.p_minRadiusV);
			p.emitRadius = startRadius;
			p.emitRadiusDelta = (endRadius - startRadius) / lifespan;
			p.emitRotation = this.p_emitAngle + getRangeWave(this.p_emitAngleV);
			p.emitRotationDelta = this.p_rotatePerSecond + getRangeWave(this.p_rotatePerSecondV);
			p.radialAcceleration = this.p_radialAccleration + getRangeWave(this.p_radialAcclerationV);
			p.tangentialAcceleration = this.p_tangentialAccleration + getRangeWave(this.p_tangentialAcclerationV);

			// 尺寸
			var startSize:Number = this.p_startSize + getRangeWave(this.p_startSizeV);
			var endSize:Number = this.p_endSize + getRangeWave(this.p_endSizeV);
			if(startSize < 0.1)
				startSize = 0.1;
			if(endSize < 0.1)
				endSize = 0.1;
			p.scale = startSize / textureWidth;
			p.scaleDelta = ((endSize - startSize) / lifespan) / textureWidth;

			// 颜色
			var startColor:ColorARGB = p.colorARGB;
			var colorDelta:ColorARGB = p.colorDelta;

			startColor.red = this.p_startColor.red + getRangeWave(this.p_startColorV.red);
			startColor.green = this.p_startColor.green + getRangeWave(this.p_startColorV.green);
			startColor.blue = this.p_startColor.blue + getRangeWave(this.p_startColorV.blue);
			startColor.alpha = this.p_startColor.alpha + getRangeWave(this.p_startColorV.alpha);

			var endColorRed:Number = this.p_endColor.red + getRangeWave(this.p_endColorV.red);
			var endColorGreen:Number = this.p_endColor.green + getRangeWave(this.p_endColorV.green);
			var endColorBlue:Number = this.p_endColor.blue + getRangeWave(this.p_endColorV.blue);
			var endColorAlpha:Number = this.p_endColor.alpha + getRangeWave(this.p_endColorV.alpha);

			colorDelta.red = (endColorRed - startColor.red) / lifespan;
			colorDelta.green = (endColorGreen - startColor.green) / lifespan;
			colorDelta.blue = (endColorBlue - startColor.blue) / lifespan;
			colorDelta.alpha = (endColorAlpha - startColor.alpha) / lifespan;

			// 旋转

			var startRotation:Number = this.p_startRotation + getRangeWave(this.p_startRotationV);
			var endRotation:Number = this.p_endRotation + getRangeWave(this.p_endRotationV);
			p.rotation = startRotation;
			p.rotationDelta = (endRotation - startRotation) / lifespan;

			addChild(p.display);
		}

		/**
		 * 创建一个粒子
		 * @return
		 *
		 */
		public function createParticle():Particle
		{
			return new Particle(texture);
		}

		/**
		 * 开始
		 * @param duration 持续总时间
		 *
		 */
		public function start(duration:Number = Number.MAX_VALUE):void
		{
			this.totalTime = duration;
			s.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
//			this.t.start();
		}

		/**
		 * 停止当前粒子播放
		 * @param clear 是否自动清理
		 *
		 */
		public function stop(clear:Boolean = false):void
		{
			s.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
//			this.t.stop();
		}

		/**
		 * 清理当前系统
		 *
		 */
		public function clear():void
		{

		}

		private var frameTime:Number;

		/**
		 * 更新时间，利用Enter_Frame 计算每帧经历时长，利用该数进行演算
		 * @param time
		 *
		 */
		public function advanceTime(time:Number):void
		{
			//			time = parseFloat(time.toFixed(3));
			//			trace(time);
			var particleIndex:int = 0;
			var p:Particle;
			var maxNumParticles:int = p_capacity;

			while(particleIndex < numParticles)
			{
				p = particles[particleIndex];
				// 如果活着。更新状态，否则修改列表
				if(p.isLive)
				{
					advanceParticle(p, time);
					++particleIndex;
				}
				else
				{
					removeChild(p.display);
					if(particleIndex != numParticles - 1)
					{
						var nextP:Particle = particles[numParticles - 1];
						particles[numParticles - 1] = p;
						particles[particleIndex] = nextP;
					}

					--numParticles;
					if(numParticles == 0 && totalTime == 0)
					{
						trace("Over1");
					}
				}
			}

			// 还有剩余时间
			if(totalTime > 0)
			{
				// 根据秒射粒子数 求每隔多久来一发新的
				var interval:Number = 1.0 / emmitRate;
				frameTime += time;
				// 发射新的粒子 
				while(frameTime > 0)
				{
					if(numParticles < maxNumParticles)
					{
						p = particles[numParticles];
						initParticle(p);

						if(p.totalTime > 0)
						{
							advanceParticle(p, frameTime);
							++numParticles
						}
					}

					frameTime -= interval;
				}

				if(totalTime != Number.MAX_VALUE)
				{
					totalTime = totalTime > time ? totalTime - time : 0;
				}

				if(numParticles == 0 && totalTime == 0)
				{
					trace("Over2");
				}
			}
		}

		private function onEnterFrameHandler(e:Event):void
		{
			var now:Number = getTimer() / 1000.0;
			var passedTime:Number = now - frameTimestamp;
			frameTimestamp = now;

			if(passedTime > 1.0)
				passedTime = 1.0;

			if(passedTime < 0.0)
				passedTime = 1.0 / s.frameRate;

			advanceTime(passedTime * 1000 / 1000);
		}

		public function get isRunning():Boolean
		{
			return this.totalTime > 0;
		}

		public function get p_capacity():int
		{
			return this._p_capacity;
		}

		public function set p_capacity(value:int):void
		{
			var i:int;
			var oldCapacity:int = p_capacity;
			var newCapacity:int = value > MAX_NUM_PARTICLES ? MAX_NUM_PARTICLES : value;
			for(i = oldCapacity; i < newCapacity; ++i)
			{
				particles[i] = createParticle();
			}

			if(newCapacity < oldCapacity)
			{
				particles.length = newCapacity;
			}
			this._p_capacity = particles.length;
			updateEmitRate();
		}

		private function advanceParticle(p:Particle, t:Number):void
		{
			var restTime:Number = p.totalTime - p.currentTime;
			t = restTime > t ? t : restTime;
			p.currentTime += t;

			if(this.p_emitType == EMITTER_TYPE_RADIAL)
			{
				p.emitRotation += p.emitRotationDelta * t;
				p.emitRadius += p.emitRadiusDelta * t;
				p.display.x = this.p_emitX + Math.cos(p.emitRotation) * p.emitRadius;
				p.display.y = this.p_emitY + Math.sin(p.emitRotation) * p.emitRadius;
			}
			else
			{
				var distanceX:Number = p.display.x - p.startX;
				var distanceY:Number = p.display.y - p.startY;
				var distanceScalar:Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
				if(distanceScalar < 0.01)
					distanceScalar = 0.01;

				var radialX:Number = distanceX / distanceScalar;
				var radialY:Number = distanceY / distanceScalar;
				var tangentialX:Number = radialX;
				var tangentialY:Number = radialY;

				radialX *= p.radialAcceleration;
				radialY *= p.radialAcceleration;

				var newY:Number = tangentialX;
				tangentialX = -tangentialY * p.tangentialAcceleration;
				tangentialY = newY * p.tangentialAcceleration;

				p.velocityX += t * (this.p_gravityX + radialX + tangentialX);
				p.velocityY += t * (this.p_gravityY + radialY + tangentialY);
				p.display.x += p.velocityX * t;
				p.display.y += p.velocityY * t;

			}
			p.scale += p.scaleDelta * t;
			p.rotation += p.rotationDelta * t;

			p.colorARGB.red += p.colorDelta.red * t;
			p.colorARGB.green += p.colorDelta.green * t;
			p.colorARGB.blue += p.colorDelta.blue * t;
			p.colorARGB.alpha += p.colorDelta.alpha * t;

			p.color = p.colorARGB.toRGB();
			p.alpha = p.colorARGB.alpha;

			p.update();
		}

		private function updateEmitRate():void
		{
			this.emmitRate = p_capacity / p_lifeSpan;
		}

		/**
		 * 求出浮动值
		 * @param v
		 * @return
		 *
		 */
		public function getRangeWave(v:Number):Number
		{
			return v * (Math.random() * 2.0 - 1.0);
		}
		//======================================粒子位置相关
		//	发射器X坐标
		public var p_emitX:Number;
		//	发射器X浮动值
		public var p_emitXV:Number;
		//	发射器Y坐标
		public var p_emitY:Number;
		//	发射器Y浮动值
		public var p_emitYV:Number;
		// 粒子喷射类型，重力型还是雷达型
		public var p_emitType:int;
		// 粒子默认播放时长
		public var p_defaultDuration:Number;

		//======================================粒子重力相关
		// 重力X
		public var p_gravityX:Number;
		// 重力Y
		public var p_gravityY:Number;
		// 速度
		public var p_speed:Number;
		// 速度浮动值
		public var p_speedV:Number;
		// 线性加速度
		public var p_radialAccleration:Number;
		// 线性加速度浮动值
		public var p_radialAcclerationV:Number;
		// 正切加速度
		public var p_tangentialAccleration:Number;
		// 正切加速度浮动值
		public var p_tangentialAcclerationV:Number;

		//======================================粒子线性相关
		// 最大半径
		public var p_maxRadius:Number;
		// 最大半径浮动值
		public var p_maxRadiusV:Number;
		// 最小半径
		public var p_minRadius:Number;
		// 最小半径浮动值
		public var p_minRadiusV:Number;
		// 每秒旋转角度
		public var p_rotatePerSecond:Number;
		// 每秒旋转角度浮动值
		public var p_rotatePerSecondV:Number;

		//======================================粒子基础属性相关
		// 粒子生命周期，即totalTime
		public var p_lifeSpan:Number;
		// 粒子生命周期浮动值
		public var p_lifeSpanV:Number;
		// 初始时大小
		public var p_startSize:Number;
		// 初始大小浮动值
		public var p_startSizeV:Number;
		// 结束时大小
		public var p_endSize:Number;
		// 结束大小浮动值
		public var p_endSizeV:Number;
		// 发射角度
		public var p_emitAngle:Number;
		// 发射角度浮动值
		public var p_emitAngleV:Number;
		// 初始化角度
		public var p_startRotation:Number;
		// 初始化角度浮动值
		public var p_startRotationV:Number;
		// 结束角度
		public var p_endRotation:Number;
		// 结束角度浮动值
		public var p_endRotationV:Number;

		//======================================粒子颜色属性相关
		// 初始颜色
		public var p_startColor:ColorARGB;
		// 初始颜色浮动值
		public var p_startColorV:ColorARGB;
		// 结束时颜色
		public var p_endColor:ColorARGB;
		// 结束颜色浮动值
		public var p_endColorV:ColorARGB;
	}
}

