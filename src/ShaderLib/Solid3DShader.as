package ShaderLib 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	/**
	 * ...
	 * @author Hejiabin
	 * @desc	va0 - position
	 * 			va1 - color
	 * 			va2 - normal
	 * 			vc0 - position transform matrix
	 * 			vc4 - normal transform matrix
	 *			vc8 - direction of the light
	 */
	public class Solid3DShader extends BaseShader 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Solid3DShader
		 */
		public function Solid3DShader(context3d:Context3D) 
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
										"mul vt3,vt2.x,va1",
										"mov v0,vt3"
									];
			var pixelShader:Array = [
										"mov oc,v0"
									];
			
			return compileShaders( vertexShader, pixelShader );
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}