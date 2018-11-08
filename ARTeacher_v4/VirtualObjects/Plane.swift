//
//  Plane.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 23/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Plane: VirtualObject {
    
    init(anchor: ARPlaneAnchor){
        super.init(identifier: VirtualObject.numberVirtualObject)
        VirtualObject.increaseVirtualObjectNumber()
        
        let width: CGFloat = 2       // CGFloat(anchor.extent.x)
        let length: CGFloat = 2       // CGFloat(anchor.extent.z)
        let planeHeight: CGFloat = 0.00001
        
        self.geometry = SCNBox(width: width, height: planeHeight, length: length, chamferRadius: 0)
        
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1, alpha: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        self.geometry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial]
        
        self.name = "plane"
        self.position = SCNVector3(anchor.center.x, anchor.center.y - Float(planeHeight) * 0.5, anchor.center.z)
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.geometry!, options: nil))
        self.physicsBody?.friction = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
