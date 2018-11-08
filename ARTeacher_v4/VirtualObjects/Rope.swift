//
//  File.swift
//  ARTeacher_v4
//
//  Created by Marian Stanciulica on 15/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit

class Rope {
    
    static var chainRings = [Ring]()
    static var ringSize: Float = 0.01
    static var direction: Direction = .RIGHT
    static var firstCubePosition = SCNVector3(0, 0, 0)
    static var secondCubePosition = SCNVector3(0, 0, 0)
    static var cubeSize: Float = 0
    
    static func initRope(direction: Direction, attachNode: VirtualObject, scene: SCNScene) {
        // set direction
        self.direction = direction
        self.firstCubePosition = attachNode.position
        self.cubeSize = Float(attachNode.height)
        
        let ringNode = Ring(direction: direction, scene: scene, neighborNode: attachNode, identifier: chainRings.count)
        
        // add ring to scene
        scene.rootNode.addChildNode(ringNode)
        
        // append ring to chain
        chainRings.append(ringNode)
    }
    
    static func addRing(scene: SCNScene) {
        
        guard let lastNode = chainRings.last else { return }
        
        let ringNode = Ring(direction: self.direction, scene: scene, neighborNode: lastNode, identifier: chainRings.count)
        
        // add ring to scene
        scene.rootNode.addChildNode(ringNode)
        
        // append ring to chain
        chainRings.append(ringNode)
    }
    
    static func attachSecondObject(scene: SCNScene, attachNode: VirtualObject) {
        
        self.secondCubePosition = attachNode.position
        self.checkRopeLength(scene: scene)
        
        guard let lastNode = chainRings.last else { return }
        
        let neighborMaxBoundingBox = attachNode.boundingBox.max
        let neighborMinBoundingBox = attachNode.boundingBox.min
        let neighborXSize = abs(neighborMaxBoundingBox.x - neighborMinBoundingBox.x)
        let neighborYSize = abs(neighborMaxBoundingBox.y - neighborMinBoundingBox.y)
        
        // create joint between attach node and first ring of the chain
        switch direction {
        case .LEFT:
            let joint = SCNPhysicsHingeJoint(bodyA: lastNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(-ringSize * 0.5, 0, 0), bodyB: attachNode.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(neighborXSize * 0.5, 0, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .RIGHT:
            let joint = SCNPhysicsHingeJoint(bodyA: lastNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(ringSize * 0.5, 0, 0), bodyB: attachNode.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(-neighborXSize * 0.5, 0, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .UP:
            let joint = SCNPhysicsHingeJoint(bodyA: lastNode.physicsBody!, axisA: SCNVector3(0, 1, 0), anchorA: SCNVector3(0, ringSize * 0.5, 0), bodyB: attachNode.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(0, -neighborYSize * 0.5, 0))
            
            scene.physicsWorld.addBehavior(joint)
        case .NONE, .DOWN:
            break
        }
    }
    
    static func checkRopeLength(scene: SCNScene) {
        
        let dist = sqrt(pow(firstCubePosition.x - secondCubePosition.x, 2) + pow(firstCubePosition.z - secondCubePosition.z, 2))
//        print("dist = \(dist)")
//        print("cube size = \(cubeSize)")
//        print("ring size = \(ringSize)")
        
        let totalRings = (dist - cubeSize) / ringSize
        
//        print("checkRopeLength total rings to add = \(totalRings)")
        
//        print(chainRings.count)
        
        let ringsToAdd =  Int(totalRings) + 1 - chainRings.count
        
//        print("checkRopeLength ring to add = \(ringsToAdd)")
        
        for _ in 0...ringsToAdd {
            Rope.addRing(scene: scene)
        }
        
    }
    
    static func removeRope(scene: SCNScene) {
        
        print("chain ring number = \(chainRings.count)")
        
        for ring in chainRings {
            ring.removeFromParentNode()
        }

        chainRings.removeAll()
        chainRings = []

        scene.physicsWorld.removeAllBehaviors()
        
    }
    
        
}
