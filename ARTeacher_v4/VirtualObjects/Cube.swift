//
//  Cube.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 16/03/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import SceneKit
import ARKit

class Cube: VirtualObject {
    
    var force: CGFloat = 0
    var forceNode: SCNNode?
    var forceDirection: Direction = .NONE
    var cubeAngle: CGFloat = 0
    
    override init(){
        super.init(identifier: VirtualObject.numberVirtualObject)
        VirtualObject.increaseVirtualObjectNumber()
        
        height = 0.1
        
        self.geometry = SCNBox(width: height, height: height, length: height, chamferRadius: 0)
        self.name = "cube"
        self.geometry?.materials = [VirtualObject.setupMaterial(materialAvailable: MaterialsAvailable.rustedIronStreaks)]
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: nil)
        
        // testing
        self.physicsBody?.mass = 0.00001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateVariables(value: CGFloat, measureUnit: String) {
        super.updateVariables(value: value, measureUnit: measureUnit)
        
//        print("Cube update variables")
        
        if measureUnit == "N" {
            force = value
        } else if measureUnit == "Kg" {
            self.physicsBody?.mass = value
        }
        
    }
    
    func addForce(forceDirection: Direction) {
        print("force direction in add force cube method = \(forceDirection)")
        
        if forceNode != nil {
            for child in forceNode!.childNodes {
                child.removeFromParentNode()
            }
            
            forceNode?.removeFromParentNode()
        }
        
        self.forceDirection = forceDirection
        forceNode = Force(parent: self, direction: forceDirection)
        self.addChildNode(forceNode!)
        
    }
    
}

