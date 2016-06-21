package com.shrimp.particle.parser
{
	import com.shrimp.particle.ParticleSystem;

	/**
	 * 数据解析器 
	 * @author Sol
	 * 
	 */	
	public interface IParser
	{
		function parse(ps:ParticleSystem, config:*):ParticleSystem;
		function getRangeWave(v:Number):Number;
	}
}