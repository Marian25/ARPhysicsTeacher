//
//  Pulley.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 06/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Pulley: VirtualObject {
    
    override init(){
        super.init(identifier: VirtualObject.numberVirtualObject)
        VirtualObject.increaseVirtualObjectNumber()
        
        let scene = SCNScene(named: "art.scnassets/pulleyA.dae")!
        
        for node in scene.rootNode.childNodes {
            node.scale = SCNVector3(0.002, 0.002, 0.002)
            node.geometry?.materials = [VirtualObject.setupMaterial(materialAvailable: MaterialsAvailable.rustedIronStreaks)]
        }
        
        self.addChildNode(scene.rootNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
