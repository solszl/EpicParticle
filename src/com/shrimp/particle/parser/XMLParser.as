package com.shrimp.particle.parser
{
	import com.shrimp.particle.ColorARGB;
	import com.shrimp.particle.ParticleSystem;

	/**
	 * XML解析器
	 * @author Sol
	 *
	 */
	public class XMLParser implements IParser
	{

		public function XMLParser()
		{
		}

		public function parse(ps:ParticleSystem, config:*):ParticleSystem
		{
			var xml:XML = XML(config);
			ps.p_emitX = parseFloat(xml.sourcePosition["@x"]);
			ps.p_emitXV = parseFloat(xml.sourcePositionVariance["@x"]);
			ps.p_emitY = parseFloat(xml.sourcePosition["@y"]);
			ps.p_emitYV = parseFloat(xml.sourcePositionVariance["@y"]);
			ps.p_speed = parseFloat(xml.speed["@value"]);
			ps.p_speedV = parseFloat(xml.speedVariance["@value"]);
			ps.p_lifeSpan = parseFloat(xml.particleLifeSpan["@value"]);
			ps.p_lifeSpanV = parseFloat(xml.particleLifespanVariance["@value"]);
			ps.p_emitAngle = parseFloat(xml.angle["@value"]);
			ps.p_emitAngleV = parseFloat(xml.angleVariance["@value"]);
			ps.p_gravityX = parseFloat(xml.gravity["@x"]);
			ps.p_gravityY = parseFloat(xml.gravity["@y"]);
			ps.p_radialAccleration = parseFloat(xml.radialAcceleration["@value"]);
			ps.p_radialAcclerationV = parseFloat(xml.radialAccelVariance["@value"]);
			ps.p_tangentialAccleration = parseFloat(xml.tangentialAcceleration["@value"]);
			ps.p_tangentialAcclerationV = parseFloat(xml.tangentialAccelVariance["@value"]);
			ps.p_startColor = getColor(xml.startColor);
			ps.p_startColorV = getColor(xml.startColorVariance);
			ps.p_endColor = getColor(xml.finishColor);
			ps.p_endColorV = getColor(xml.finishColorVariance);
			ps.p_capacity = parseInt(xml.maxParticles["@value"]);
			ps.p_startSize =  parseFloat(xml.startParticleSize["@value"]);
			ps.p_startSizeV =  parseFloat(xml.startParticleSizeVariance["@value"]);
			ps.p_endSize =  parseFloat(xml.finishParticleSize["@value"]);
			ps.p_endSizeV =  parseFloat(xml.FinishParticleSizeVariance["@value"]);
			ps.p_defaultDuration = parseFloat(xml.duration["@value"]);
			ps.p_emitType = parseInt(xml.emitterType["@value"]);
			ps.p_maxRadius = parseFloat(xml.maxRadius["@value"]);
			ps.p_maxRadiusV =  parseFloat(xml.maxRadiusVariance["@value"]);
			ps.p_minRadius = parseFloat(xml.minRadius["@value"]);
			ps.p_minRadiusV =  parseFloat(xml.minRadiusVariance["@value"]);
			ps.p_rotatePerSecond =  parseFloat(xml.rotatePerSecond["@value"]);
			ps.p_rotatePerSecondV = parseFloat(xml.rotatePerSecondVariance["@value"]);
			ps.p_startRotation = parseFloat(xml.rotationStart["@value"]);
			ps.p_startRotationV = parseFloat(xml.rotationStartVariance["@value"]);
			ps.p_endRotation = parseFloat(xml.rotationEnd["@value"]);
			ps.p_endRotationV = parseFloat(xml.rotationEndVariance["@value"]);

			ps.emmitRate = ps.p_capacity / ps.p_lifeSpan;

			function getColor(element:XMLList):ColorARGB
			{
				var color:ColorARGB = new ColorARGB();
				color.red = parseFloat(element.attribute("red"));
				color.green = parseFloat(element.attribute("green"));
				color.blue = parseFloat(element.attribute("blue"));
				color.alpha = parseFloat(element.attribute("alpha"));
				return color;
			}
			return ps;
		}

		public function getRangeWave(v:Number):Number
		{
			return 0;
		}
	}
}

/*
   <?xml version="1.0"?>
   <particleEmitterConfig>
   <texture name="drugs_particle.png"/>
   <sourcePosition x="160.00" y="211.72"/>
   <sourcePositionVariance x="30.00" y="30.00"/>
   <speed value="98.00"/>
   <speedVariance value="211.00"/>
   <particleLifeSpan value="4.0000"/>
   <particleLifespanVariance value="4.0000"/>
   <angle value="360.00"/>
   <angleVariance value="190.00"/>
   <gravity x="0.70" y="1.43"/>
   <radialAcceleration value="0.00"/>
   <tangentialAcceleration value="0.00"/>
   <radialAccelVariance value="0.00"/>
   <tangentialAccelVariance value="0.00"/>
   <startColor red="0.32" green="0.39" blue="0.58" alpha="0.76"/>
   <startColorVariance red="0.42" green="0.75" blue="0.88" alpha="0.08"/>
   <finishColor red="0.79" green="0.85" blue="0.42" alpha="0.57"/>
   <finishColorVariance red="0.45" green="0.51" blue="0.26" alpha="0.46"/>
   <maxParticles value="600"/>
   <startParticleSize value="50.00"/>
   <startParticleSizeVariance value="50.00"/>
   <finishParticleSize value="30.00"/>
   <FinishParticleSizeVariance value="10.00"/>
   <duration value="-1.00"/>
   <emitterType value="0"/>
   <maxRadius value="100.00"/>
   <maxRadiusVariance value="0.00"/>
   <minRadius value="0.00"/>
   <rotatePerSecond value="0.00"/>
   <rotatePerSecondVariance value="0.00"/>
   <blendFuncSource value="1"/>
   <blendFuncDestination value="1"/>
   <rotationStart value="0.00"/>
   <rotationStartVariance value="0.00"/>
   <rotationEnd value="0.00"/>
   <rotationEndVariance value="0.00"/>
   </particleEmitterConfig>
 */


