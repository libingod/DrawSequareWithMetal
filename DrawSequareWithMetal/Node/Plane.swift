//
//  Plane.swift
//  DrawSequareWithMetal
//
//  Created by 刘李斌 on 2017/11/22.
//  Copyright © 2017年 Brilliance. All rights reserved.
//

import Foundation
import MetalKit

class Plane: Node {
    //优化 - 用两个数组相结合  vertices数组存放正方形的顶点坐标, indces数组存放每次使用vertices数组中的哪三组数据作为三角形的顶点就行绘制
    var vertices: [Float] = [
        -1,1,0,
        -1,-1,0,
        1,-1,0,
        1,1,0
    ]
    
    var indces: [UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    var vertexBuffer: MTLBuffer?
    
    //索引缓冲区
    var indexBuffer: MTLBuffer?
    
    //动画的一些参数
    //创建移动量
    struct Constants {
        var animateBy: Float = 0.0
    }
    
    var constant = Constants()
    
    var time: Float = 0
    
    //处理顶点
    func buildBuffer(device: MTLDevice){
        //创建顶点缓冲区,保存了顶点数组中的顶点位置
        //每一个条目都是一个float, 所以缓冲区的长度也就是顶点的数量
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
        
        indexBuffer = device.makeBuffer(bytes: indces, length: indces.count * MemoryLayout<Float>.size, options: [])
    }
    
    init(device: MTLDevice) {
        super.init()
        buildBuffer(device: device)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, detailTime: Float) {
        super.render(commandEncoder: commandEncoder, detailTime: detailTime)
        
        //确认indexBuffer不为空
        guard let indexBuffer = indexBuffer else { return  }
        time += detailTime
        let animateBy = abs(sin(time) / 2 + 0.5)
        constant.animateBy = animateBy
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&constant, length: MemoryLayout<Constants>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indces.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
    }
}




















