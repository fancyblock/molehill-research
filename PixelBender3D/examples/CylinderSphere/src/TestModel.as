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

import com.adobe.pixelBender3D.utils.VertexBufferHelper;
import flash.geom.*;
import flash.display3D.*;

public class TestModel
{
    
    public function TestModel(
        vertexBufferHelper : VertexBufferHelper,
        transform : Matrix3D,
        triangleDataIndexBuffer : IndexBuffer3D,
        nTriangles : int )
    {
        vertexBufferHelper_ = vertexBufferHelper;
        transform_ = transform;
        triangleDataIndexBuffer_ = triangleDataIndexBuffer;
        numTriangles_ = nTriangles;
    }

    public function get vertexBufferHelper() : VertexBufferHelper
    {
        return vertexBufferHelper_;
    }

    public function get transform() : Matrix3D
    {
        return transform_;
    }

    public function set transform( value : Matrix3D ) : void
    {
        transform_ = value;
    }

    public function get numTriangles() : int
    {
        return numTriangles_;
    }

    public function get triangleDataIndexBuffer() : IndexBuffer3D
    {
        return triangleDataIndexBuffer_;
    }

    private var vertexBufferHelper_ : VertexBufferHelper;
    private var transform_ : Matrix3D = new Matrix3D();
    private var numTriangles_ : int;
    private var triangleDataIndexBuffer_ : IndexBuffer3D;
}

} // package

