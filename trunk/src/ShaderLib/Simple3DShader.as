package ShaderLib 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	/**
	 * ...
	 * @author Hejiabin
	 * @desc	va0 - position
	 * 			va2 - normal
	 * 			va3 - uv
	 * 			vc0 - position transform matrix
	 * 			vc4 - normal transform matrix
	 *			vc8 - direction of the light
	 * 			fs0 - texture
	 */
	public class Simple3DShader extends BaseShader 
	{
		//-------------------------------- static member ------------------------------------
		
		//-------------------------------- private member -----------------------------------
		
		//-------------------------------- public function ----------------------------------
		
		/**
		 * @desc	constructor of Simple3DShader
		 */
		public function Simple3DShader(context3d:Context3D) 
		{
			super(context3d);
		}
		
		/**
		 * @desc	return the shaders
		 */
		override public function get SHADERS():Program3D
		{
			var vertexShader:Array = [
										"m44 op,va0,vc0",
										"m44 vt4,va2,vc4",
										"neg vt1,vc8",
										"dp3 vt2.x,vt4,vt1",
										"mov v0,va0",
										"mov v0.x,vt2.x",
										"mov v1,va3"
									];
			var pixelShader:Array = [
										"tex ft0,v1,fs0<2d,clamp,linear>",
										"mul ft1,ft0,v0.x",
										"mov oc,ft1"
									];
			
			return compileShaders( vertexShader, pixelShader );
		}
		
		//-------------------------------- private function ---------------------------------
		
		//-------------------------------- callback function --------------------------------
		
	}

}