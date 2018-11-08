//
//  Ramp.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 24/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Ramp: VirtualObject {
    
    var horizontalScale: CGFloat = 1.0
    var planeAngle: CGFloat = 30.0
    var friction: CGFloat = 0.5
    var size: CGFloat = 0.4
    var length: CGFloat = 0
    
    override init(){
        super.init(identifier: VirtualObject.numberVirtualObject)
        VirtualObject.increaseVirtualObjectNumber()
        
        height = size * sin(CGFloat.pi * planeAngle / 180.0)
        length = size * cos(CGFloat.pi * planeAngle / 180.0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: length * 0.5, y: -height * 0.5))
        path.addLine(to: CGPoint(x: -length * 0.5, y: -height * 0.5))
        path.addLine(to: CGPoint(x: length * 0.5, y: height * 0.5))
        path.close()

        self.name = "ramp"
        self.geometry = SCNShape(path: path, extrusionDepth: size * 0.5)
        self.geometry?.materials = [VirtualObject.setupMaterial(materialAvailable: MaterialsAvailable.rustedIronStreaks)]
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: self.geometry!, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateVariables(value: CGFloat, measureUnit: String) {
        super.updateVariables(value: value, measureUnit: measureUnit)
        
        if measureUnit == "°" {
            self.planeAngle = value
        } else if measureUnit == "m" {
            self.height = value
        } else if measureUnit == "" {
            self.friction = value
            self.physicsBody?.friction = value
        }
        
        self.updateGeometry()
    }
    
    func updateGeometry() {
        self.size = self.height / sin(CGFloat.pi * self.planeAngle / 180.0)
        self.length = self.size * cos(CGFloat.pi * self.planeAngle / 180.0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.length * 0.5, y: -self.height * 0.5))
        path.addLine(to: CGPoint(x: -self.length * 0.5, y: -self.height * 0.5))
        path.addLine(to: CGPoint(x: self.length * 0.5, y: self.height * 0.5))
        path.close()
        
        self.geometry = SCNShape(path: path, extrusionDepth: self.size * 0.5)
        self.geometry?.materials = [VirtualObject.setupMaterial(materialAvailable: MaterialsAvailable.rustedIronStreaks)]
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: self.geometry!, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
    }
    
    override func showVariables() {
        print("PlaneAngle: \(self.planeAngle)")
        print("Length: \(self.size)")
        print("Friction: \(self.friction)")
    }

}
