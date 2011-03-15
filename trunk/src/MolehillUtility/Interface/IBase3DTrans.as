package MolehillUtility.Interface 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IBase3DTrans 
	{
		function GetTransMatrix():Matrix3D;
		
		function SetPerspective( fovy:Number, aspect:Number ):void;
		
		function LookAt( org:Vector3D, dest:Vector3D, up:Vector3D ):void;
		
		function get WORLD_MATRIX():Matrix3D;
		
		function get CAMERA_MATRIX():Matrix3D;
		
		function WorldIdentity():void;
		
		function CameraIdentity():void;
		
		function SetWorldMatrix( matrix:Matrix3D ):void;
		
		function SetProjectMatrix( matrix:Matrix3D ):void;
		
		function SetCameraMatrix( matrix:Matrix3D ):void;
	}
	
}