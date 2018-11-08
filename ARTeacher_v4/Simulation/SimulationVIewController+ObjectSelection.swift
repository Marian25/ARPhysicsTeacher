//
//  SimulationVIewController+ObjectSelection.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 04/03/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import ARKit

extension SimulationViewController: VirtualObjectSelectionCollectionViewDelegate {
    
    /// Method to place a virtual object on focus square
    func placeVirtualObject(_ objectName: String) {

        let virtualObject = self.instantiateVirtualObject(objectName: objectName)
        self.virtualObjects.append(virtualObject)
        
        virtualObjectInteraction.selectedObject = virtualObject
        
        if objectName == "pulley" {
            virtualObject.rotationEnabled = false
            let listRampNode = virtualObjectInteraction.checkForInteractionWhilePanning(typeOfOjectsInteracting: ["ramp"]) as! [Ramp]
            
            if let firstNode = listRampNode.first {
                print("first node plane angle = \(firstNode.planeAngle)")
                virtualObject.eulerAngles.z = -.pi / 4
                virtualObject.position = SCNVector3(firstNode.length * 0.5, firstNode.height * 0.5, 0)
                
                firstNode.addChildNode(virtualObject)
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
            }
            
        } else {
            virtualObject.transform = SCNMatrix4Identity
            virtualObject.position = SCNVector3(focusSquare.position.x, focusSquare.position.y + Float(virtualObject.height) * 0.5, focusSquare.position.z)
//            print("virtual object rotation = \(virtualObject.rotation)")
//            print("virtual object position = \(virtualObject.position)")
            
            virtualObject.eulerAngles = SCNVector3(0, 0, 0)
        }
        
        updateQueue.async {
            if objectName != "pulley" {
                self.sceneView.scene.rootNode.addChildNode(virtualObject)
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
            }
        }
        
    }
    
    func virtualObjectSelectionCollectionView(_ selectionViewController: VirtualObjectSelectionCollectionViewController, didSelectObject objectName: String) {
        
        DispatchQueue.main.async {
            self.placeVirtualObject(objectName)
            
        }
        
    }
    
    func instantiateVirtualObject(objectName: String) -> VirtualObject {
        
        switch objectName {
        case "cube":
            let virtualObject = Cube()
            
            if enableDigitInputTextField {
                messageView.queueMessage(message: "Insert value for mass!")
                VirtualObjectInteraction.digitInput?.showDigitInput(measureUnit: "Kg", parentNode: virtualObject)
            }
            
            return virtualObject
        case "pulley":
            let virtualObject = Pulley()
            return virtualObject
        case "ramp":
            let virtualObject = Ramp()
            
            if enableDigitInputTextField {
                VirtualObjectInteraction.digitInput?.showDigitInputForRamp(parentNode: virtualObject)
            }
            
            return virtualObject
        default:
            return VirtualObject(identifier: VirtualObject.numberVirtualObject)
        }
        
    }
    
}
