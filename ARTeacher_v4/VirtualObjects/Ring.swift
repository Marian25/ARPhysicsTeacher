//
//  Ring.swift
//  ARTeacher_v4
//
//  Created by Marian Stanciulica on 29/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit

class Ring: VirtualObject {
    
    var identifierInRope = 0
    
    init(direction: Direction, scene: SCNScene, neighborNode: SCNNode, identifier: Int) {
        super.init(identifier: VirtualObject.numberVirtualObject)
        VirtualObject.increaseVirtualObjectNumber()
        
        self.identifierInRope = identifier
        
        // setup material for ring
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        material.specular.contents = UIColor.red
        material.locksAmbientWithDiffuse = true
        
        // create ring and calculate position offset
        let neighborMaxBoundingBox = neighborNode.boundingBox.max
        let neighborMinBoundingBox = neighborNode.boundingBox.min
        let neighborXSize = abs(neighborMaxBoundingBox.x - neighborMinBoundingBox.x)
        let neighborYSize = abs(neighborMaxBoundingBox.y - neighborMinBoundingBox.y)
        
        // compute position based on rope direction
        switch direction {
        case .LEFT:
            self.position = SCNVector3(neighborNode.position.x - neighborXSize / 2.0 - Rope.ringSize / 2.0, neighborNode.position.y, neighborNode.position.z)
        case .RIGHT:
            self.position = SCNVector3(neighborNode.position.x + neighborXSize / 2.0 + Rope.ringSize / 2.0, neighborNode.position.y, neighborNode.position.z)
        case .UP:
            self.position = SCNVector3(neighborNode.position.x, neighborNode.position.y + neighborYSize / 2 + Rope.ringSize / 2, neighborNode.position.z)
        case .NONE, .DOWN:
            break
        }

        // set ring geometry and physics body
        self.name = "ring"
        
        // code for making cylinder ring (nedd to change joints)
//        self.geometry = SCNCylinder(radius: CGFloat(Rope.ringSize * 0.5), height: CGFloat(Rope.ringSize))
//        self.eulerAngles.z = .pi / 2
        self.geometry =  SCNBox(width: CGFloat(Rope.ringSize), height: CGFloat(Rope.ringSize), length: CGFloat(Rope.ringSize), chamferRadius: 0)
        self.geometry?.firstMaterial = material
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.mass = 0.001
        self.physicsBody?.isAffectedByGravity = false
        
        switch direction {
        case .LEFT:
            let joint = SCNPhysicsHingeJoint(bodyA: neighborNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(-neighborXSize * 0.5, 0, 0), bodyB: self.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(Rope.ringSize * 0.5, 0, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .RIGHT:
            let joint = SCNPhysicsHingeJoint(bodyA: neighborNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(neighborXSize * 0.5, 0, 0), bodyB: self.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(-Rope.ringSize * 0.5, 0, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .UP:
            let joint = SCNPhysicsHingeJoint(bodyA: neighborNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(0, neighborYSize * 0.5, 0), bodyB: self.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(0, -Rope.ringSize * 0.5, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .NONE, .DOWN:
            break
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
