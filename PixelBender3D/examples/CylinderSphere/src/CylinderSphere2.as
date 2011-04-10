/*****************************************************************************
*
* ADOBE SYSTEMS INCORPORATED
* Copyright (C) 2011 Adobe Systems Incorporated
* All Rights Reserved.
*
* NOTICE:  Adobe permits you to use, modify, and distribute this file in 
* accordance with the terms of the Adobe license agreement accompanying it.  
* If you have received this file from a source other than Adobe, then your 
* use, modification, or distribution of it requires the prior written 
* permission of Adobe.
*
*****************************************************************************/

package
{

import com.adobe.pixelBender3D.AGALProgramPair;
import com.adobe.pixelBender3D.PBASMProgram;
import com.adobe.pixelBender3D.RegisterMap;
import com.adobe.pixelBender3D.VertexRegisterInfo;
import com.adobe.pixelBender3D.utils.ProgramConstantsHelper;
import com.adobe.pixelBender3D.utils.VertexBufferHelper;

import flash.display.*;
import flash.display3D.*;
import flash.display3D.textures.*;
import flash.events.*;
import flash.geom.*;
import flash.utils.*;

public class CylinderSphere2
{
    [Embed (source="../res/BulgeVertexProgram.pb3dasm", mimeType="application/octet-stream")]
    private static const bulgeVertexProgram : Class;

    [Embed (source="../res/phongShaderCylinderSphereMaterialVertexTextured.pb3dasm", mimeType="application/octet-stream")]
    private static const phongMaterialVertexProgramTextured : Class;
            
    [Embed (source="../res/phongShaderCylinderSphereMaterialTextured.pb3dasm", mimeType="application/octet-stream")]
    private static const phongFragmentProgramTextured : Class;

    [Embed( source = "../res/YellowFlowers512x512.png" )]
    protected const flowersBitmap:Class;

    public function CylinderSphere2( stage : Stage, context : Context3D )
    {
        vWidth_ = stage.width;
        vHeight_ = stage.height;

        context3D_ = context;

        aspect_ = vWidth_ / vHeight_;
        
        initResources();

        context3D_.setDepthTest( true, Context3DCompareMode.LESS );
        context3D_.setCulling( Context3DTriangleFace.NONE );

        context3D_.setProgram ( shaderProgram_ );
        context3D_.setTextureAt( 0, texture_ );
    }

    public function initResources() : void
    {
        var depthstencil : Boolean = true;
        context3D_.configureBackBuffer( vWidth_, vHeight_, 0, depthstencil );

        var bitmap:Bitmap = new flowersBitmap();

        texture_ = context3D_.createTexture( bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false );
        texture_.uploadFromBitmapData( bitmap.bitmapData );

        initializePrograms();
        initializeModels();
    }

    private function initializePrograms() : void
    {
        var inputVertexProgram : PBASMProgram = new PBASMProgram( readFile( bulgeVertexProgram ) );

        var inputMaterialVertexProgram : PBASMProgram = new PBASMProgram( readFile( phongMaterialVertexProgramTextured ) );
        var inputFragmentProgram : PBASMProgram = new PBASMProgram( readFile( phongFragmentProgramTextured ) );

        var programs : com.adobe.pixelBender3D.AGALProgramPair = com.adobe.pixelBender3D.PBASMCompiler.compile( inputVertexProgram, inputMaterialVertexProgram, inputFragmentProgram );

        var agalVertexBinary : ByteArray = programs.vertexProgram.byteCode;
        var agalFragmentBinary : ByteArray = programs.fragmentProgram.byteCode;

        vertexRegisterMap_ = programs.vertexProgram.registers;
        fragmentRegisterMap_ = programs.fragmentProgram.registers;

        parameterBufferHelper_ = new ProgramConstantsHelper( context3D_, vertexRegisterMap_, fragmentRegisterMap_ );

        shaderProgram_ = context3D_.createProgram();
        shaderProgram_.upload( agalVertexBinary, agalFragmentBinary );
    }

    private function initializeModels() : void
    {
        models_ = new Vector.< TestModel >();
        
        var cylinderRadius : Number = 2.0;
        var cylinderHalfHeight : Number = 3.0;

        var sphereRadius : Number = 2.5;

        var nSegmentsAround : int = 30;
        var nRowsHalf : int = 10;

        models_.push( getCylinderSphereModel( cylinderRadius, cylinderHalfHeight, sphereRadius, nSegmentsAround, nRowsHalf, vertexRegisterMap_.vertexRegisters ) );
    }

    public function render( t : Number ) : void
    {
        context3D_.clear( 0.5, 0.5, 0.5, 1 );

        var angle : Number = t / 3000.0;
        var cameraPosition : Vector3D = new Vector3D( cameraRadius_ * Math.sin( angle ), height_, cameraRadius_ * Math.cos( angle ) );

        var lightAngle : Number = t / 2000.0;
        var lightRadius : Number = 10.0;
        lightPosition_ = new Vector3D( lightRadius * Math.sin( lightAngle ), lightRadius * Math.cos( lightAngle ), 0.0 );

        var centreOfInterest : Vector3D = new Vector3D( 0.0, 0.0, 0.0 );

        parameterBufferHelper_.setNumberParameterByName(
            Context3DProgramType.VERTEX, 
            "scale",
            Vector.<Number>([scale_]));

        parameterBufferHelper_.setNumberParameterByName(
            Context3DProgramType.VERTEX, 
            "scalea",
            Vector.<Number>([scale_]));

        parameterBufferHelper_.setNumberParameterByName(
            Context3DProgramType.VERTEX, 
            "lightPosition",
            Vector.<Number>([lightPosition_.x, lightPosition_.y, lightPosition_.z, 0]));

        for each( var m : TestModel in models_ )
        {
            drawModel( m, cameraPosition, centreOfInterest );
        }

        context3D_.present();
    }

    public function drawModel( model : TestModel, cameraPosition : Vector3D, centreOfInterest : Vector3D ) : void
    {
        var transposed : Boolean = true;
        parameterBufferHelper_.setMatrixParameterByName(
                Context3DProgramType.VERTEX, 
                "objectToClipSpaceTransform",
                getClipMatrix( model.transform, cameraPosition, centreOfInterest ), 
                transposed );

        parameterBufferHelper_.update();

        model.vertexBufferHelper.setVertexBuffers();
        context3D_.drawTriangles( model.triangleDataIndexBuffer, 0, model.numTriangles );
    }

        private function getClipMatrix( 
            modelTransform : Matrix3D,
            cameraPosition : Vector3D, 
            centreOfInterest : Vector3D ) : Matrix3D
        {
            var clipMatrix : Matrix3D = new Matrix3D();

            clipMatrix.append( modelTransform );

            var viewMatrix:Matrix3D = getInvertedCameraMatrix( cameraPosition, centreOfInterest );
            clipMatrix.append( viewMatrix );

            clipMatrix.append( projectionMatrix );

            return clipMatrix;
        }

    private function get projectionMatrix():Matrix3D
    {
        var near:Number = .02;
        var far:Number = 100000;
        var fov:Number = 60;

        var DEG2RAD : Number = Math.PI / 360.0;

        var y:Number = near * Math.tan( fov * DEG2RAD ); 
        var x:Number = y * aspect_;

        var projectionMatrix:Matrix3D = new Matrix3D(
            Vector.<Number>(
            [
                near/x,			0,				0,				0,
                0,				near/y,			0,				0,
                0,				0,				(far+near)/(near-far),	-1,
                0,				0,				(2*far*near)/(near-far),	0
            ]
            )
        );
        return projectionMatrix;
    }

    private function readFile( f : Class ) : String
    {
        var bytes:ByteArray;

        bytes = new f();
        return bytes.readUTFBytes( bytes.bytesAvailable );
    }

    public function setParam(
        index:int, 
        value:Number ) : void
    {
        if( index == 0 )
        {
            scale_ = value / 100.0;
        }
        else if( index == 1 )
        {
            cameraRadius_ = 3.0 + 10.0 * value / 100.0;
        }
    }

    public function getInvertedCameraMatrix(
        cameraPosition : Vector3D,
        centreOfInterest : Vector3D ) : Matrix3D
    {
        var m : Matrix3D = getCameraMatrix( cameraPosition, centreOfInterest );
        m.invert();

        return m;
    }

    public function getCameraMatrix(
        cameraPosition : Vector3D,
        centreOfInterest : Vector3D ) : Matrix3D
    {
        var v : Vector3D = centreOfInterest.subtract( cameraPosition );

        // The camera points along the negative Z axis
        v.negate();

        var zVector : Vector3D = v;
        var upVector : Vector3D = new Vector3D( 0.0, 1.0, 0.0 );

        var xVector : Vector3D = upVector.crossProduct( zVector );
        var yVector : Vector3D = zVector.crossProduct( xVector );

        xVector.normalize()
        yVector.normalize()
        zVector.normalize()

        var result : Matrix3D = new Matrix3D;
        result.rawData = Vector.<Number>( [
            xVector.x, xVector.y, xVector.z, 0.0,
            yVector.x, yVector.y, yVector.z, 0.0,
            zVector.x, zVector.y, zVector.z, 0.0,
            cameraPosition.x, cameraPosition.y, cameraPosition.z, 1.0
            ] );

        return result
    }

    // Create a model that can transform between a cylinder and a sphere
    private function getCylinderSphereModel(
        cylinderRadius : Number,
        cylinderHalfHeight : Number,
        sphereRadius : Number,
        nSegmentsAround : int,
        nRowsHalf : int,
        vertexRegisters : Vector.<VertexRegisterInfo> ) : TestModel
    {
        var vertexBufferData : Vector.<Number> = new Vector.<Number>();
        var numVertices : int = 0;

        var triangles : Vector.<uint> = new Vector.<uint>();

        var color0 : Vector3D = new Vector3D( 1.0, 0.0, 0.0, 1.0 );
     
        for( var i : int  = 0; i < nRowsHalf * 2 + 1; ++i )
        {
            var i0 : int = i - nRowsHalf;
            
            var yCylinder : Number = ( i0 * cylinderHalfHeight ) / ( nRowsHalf );
            var ySphere : Number = ( i0 * sphereRadius ) / ( nRowsHalf );

            var sphereRadiusAtY : Number = Math.sqrt( sphereRadius * sphereRadius - ySphere * ySphere );

            var v : Number = 1.0 - ( i / ( nRowsHalf * 2 ) );
            
            for( var j : uint = 0; j < nSegmentsAround + 1; ++j )
            {
                var u : Number = 1.0 - ( j / ( nSegmentsAround ) );

                var angle : Number = ( j * 2.0 * Math.PI ) / ( nSegmentsAround );
                
                var xCylinder : Number = cylinderRadius * Math.cos( angle );
                var zCylinder : Number = cylinderRadius * Math.sin( angle );

                var xSphere : Number = sphereRadiusAtY * Math.cos( angle );
                var zSphere : Number = sphereRadiusAtY * Math.sin( angle );

                var position : Vector3D = new Vector3D( xCylinder, yCylinder, zCylinder, 1.0 );

                // Set up the normal to let us morph from the cylinder to the sphere                    
                var normal : Vector3D = new Vector3D( xSphere - xCylinder, ySphere - yCylinder, zSphere - zCylinder, 0.0 );

                addVertex( vertexBufferData, position, color0, normal, u, v, vertexRegisters );
                numVertices += 1;
                
                var n : int = nSegmentsAround + 1;
                
                if( i != 0 && j != nSegmentsAround )
                {
                    var p0 : int = ( i * n + j );
                    var p1 : int = ( ( i - 1 ) * n + j );
                    var p2 : int = ( ( i - 1 ) * n + j + 1 );
                    var p3 : int = ( i * n + j + 1 );
                    
                    triangles.push(
                        p0,
                        p1,
                        p2 );

                    triangles.push(
                        p0,
                        p2,
                        p3 );
                }
            }
        }

        var numFloatsPerVertex : int = VertexBufferHelper.numFloatsPerVertex( vertexRegisters );
        
        var vertexBuffer : VertexBuffer3D = context3D_.createVertexBuffer( numVertices, numFloatsPerVertex );
        vertexBuffer.uploadFromVector( vertexBufferData, 0, numVertices );

        var numTriangles : int = triangles.length / 3;
        
        var triangleDataIndexBuffer : IndexBuffer3D = context3D_.createIndexBuffer( numTriangles * 3 );
        triangleDataIndexBuffer.uploadFromVector( triangles, 0, numTriangles * 3 );

        return new TestModel(
            new VertexBufferHelper(
                context3D_,
                vertexRegisters,
                vertexBuffer ),
            
            new Matrix3D(),
            triangleDataIndexBuffer,
            numTriangles );
    }

    private function addVertex( 
        vertexBufferData : Vector.<Number>, 
        position : Vector3D, 
        color : Vector3D, 
        normal : Vector3D, 
        u : Number, 
        v : Number,
        vertexRegisters : Vector.<VertexRegisterInfo> ) : void
    {
        for (var j : int = 0 ; j < vertexRegisters.length ; j += 1)
        {
            var n : int = nFloats( vertexRegisters[ j ].format );

            if( vertexRegisters[ j ].semantics.id == "PB3D_POSITION" )
            {
                vertexBufferData.push( position.x, position.y, position.z );
                if( n == 4 )
                    vertexBufferData.push( 1.0 );
            }

            if( vertexRegisters[ j ].semantics.id == "PB3D_COLOR" )
            {
                vertexBufferData.push( color.x, color.y, color.z );
                if( n == 4 )
                    vertexBufferData.push( 1.0 );
            }

            if( vertexRegisters[ j ].semantics.id == "PB3D_NORMAL" )
            {
                vertexBufferData.push( normal.x, normal.y, normal.z );
                if( n == 4 )
                    vertexBufferData.push( 0.0 );
            }
            
            if( vertexRegisters[ j ].semantics.id == "PB3D_UV" )
            {
                vertexBufferData.push( u, v );
                if( n == 3 )
                    vertexBufferData.push( 0.0 );
                if( n == 4 )
                    vertexBufferData.push( 0.0, 0.0 );
            }
        }
    }

    public function nFloats( format : String ) : int
    {
        if( format == "float1" )
            return 1;
        if( format == "float2" )
            return 2;
        if( format == "float3" )
            return 3;
        if( format == "float4" )
            return 4;

        throw new Error( "bad format" );

        return 0;
    }


    private var shaderProgram_ : Program3D;

    private var models_ : Vector.< TestModel >;

    private var aspect_ : Number;
    private var scale_ : Number = 0.0;
    private var angle_ : Number = 0.0;
    private var height_ : Number = 6.0;
    private var cameraRadius_ : Number = 5.3;

    private var vertexRegisterMap_ : RegisterMap;
    private var fragmentRegisterMap_ : RegisterMap;

    private var texture_ : Texture;

    private var lightPosition_ : Vector3D = new Vector3D( 10.0, 0.0, 10.0 );

    public var context3D_ : Context3D;

    public var parameterBufferHelper_ : ProgramConstantsHelper;

    private var vWidth_ : int;
    private var vHeight_ : int;
}

}

