//
//  Force.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 06/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Force: SCNNode {
    
    let forceArrowRadius: CGFloat = 0.03
    let forceArrowHeight: CGFloat = 0.03
    let forceBodyRadius: CGFloat = 0.005
    let forceBodyHeight: CGFloat = 0.1
    
    init(parent: SCNNode, direction: Direction) {
        super.init()
        
        let forceArrowGeometry = SCNCone(topRadius: 0, bottomRadius: forceArrowRadius, height: forceArrowHeight)
        let forceBodyGeometry = SCNCylinder(radius: forceBodyRadius, height: forceBodyHeight)
        
        forceArrowGeometry.firstMaterial?.diffuse.contents = UIColor(red: 70/255, green: 178/255, blue: 240/255, alpha: 1)
        forceBodyGeometry.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 178/255, blue: 240/255, alpha: 1)
        
        let forceArrowNode = SCNNode(geometry: forceArrowGeometry)
        forceArrowNode.position = SCNVector3(0, forceBodyHeight / 2, 0)
        
        let forceBodyNode = SCNNode(geometry: forceBodyGeometry)
        
        self.name = "force"
        self.addChildNode(forceBodyNode)
        self.addChildNode(forceArrowNode)
        
        let offset: CGFloat = CGFloat(parent.boundingBox.max.z - parent.boundingBox.min.z)
        
        switch direction {
        case .RIGHT:
            self.position = SCNVector3(-0.5 * (offset + forceArrowHeight + forceBodyHeight), 0, 0)
            self.eulerAngles.z = -.pi / 2
        case .LEFT:
            self.position = SCNVector3(0.5 * (offset + forceArrowHeight + forceBodyHeight), 0, 0)
            self.eulerAngles.z = .pi / 2
        case .UP:
            self.position = SCNVector3(0, 0.5 * (offset + forceArrowHeight + forceBodyHeight), 0)
        case .DOWN:
            self.position = SCNVector3(0, -0.5 * (offset + forceArrowHeight + forceBodyHeight), 0)
            self.eulerAngles.z = .pi
        default:
            break
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
