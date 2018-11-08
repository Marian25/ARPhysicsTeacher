//
//  Text.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 07/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import ARKit

class Text: SCNNode {
    
    init(text: String, currentMeasureUnit: String, tappedObject: VirtualObject) {
        super.init()
//        super.init(identifier: VirtualObject.numberVirtualObject)
//        VirtualObject.increaseVirtualObjectNumber()
//
        self.geometry = SCNText(string: text + " \(currentMeasureUnit)", extrusionDepth: 1)
        self.geometry?.materials = [VirtualObject.setupMaterial(materialAvailable: MaterialsAvailable.sculptedFloorBoards)]
        self.name = "text"
        
//        let numberChars: Double = Double(text.count + 1 + currentMeasureUnit.count)
//        let offset = 0.015 * numberChars / 2.0
//        let rightOffset = 0.05 * numberChars / 2.0
        
        self.scale = SCNVector3(0.002, 0.002, 0.002)
        
        let min = self.boundingBox.min
        let max = self.boundingBox.max
        self.pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2, 0, 0)
        
        switch currentMeasureUnit {
        case "N":
            print("testing text node position when is used on forces = \(self.position)")
            
            if let cubeNode = tappedObject as? Cube {
                switch cubeNode.forceDirection {
                case .RIGHT:
                    print("update text node position with offset direction right")
//                    self.position = SCNVector3(-rightOffset, 0, 0)
                    self.eulerAngles.z = .pi / 2
                case .LEFT:
                    print("update text node position with offset direction left")
//                    self.position = SCNVector3(offset, 0, 0)
                    self.eulerAngles.z = -.pi / 2
                case .UP:
                    self.position.z += 0.01
                    self.position.y += 0.05
                case .DOWN:
                    self.position.z += 0.01
                    self.position.y += 0.08
                    self.eulerAngles.z = .pi
                case .NONE:
                    break
                }
            }
            
        case "Kg":
            self.position = SCNVector3(0, tappedObject.height * 0.5, 0)
        case "°":
            if let rampNode = tappedObject as? Ramp {
                self.position = SCNVector3(0, 0, 0)
                self.eulerAngles.z = Float(rampNode.planeAngle * .pi / 180.0)
            }
            
        default:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
