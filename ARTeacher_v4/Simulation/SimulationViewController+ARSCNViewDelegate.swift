//
//  SimulationViewController+ARSCNViewDelegate.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 28/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import ARKit


extension SimulationViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            
            if tappingVirtualObjectsMode != .SimulationMode {
                self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
                self.updateFocusSquare()
                
                if VirtualObjectInteraction.digitInput?.currentMeasureUnit == "N" && VirtualObjectInteraction.digitInput?.endEditing == false {
                    self.forceDirectionView.isHidden = false
//                    print("virtual object interation force direction = \(self.virtualObjectInteraction.currentForceDirection)")
                } else {
                    self.forceDirectionView.isHidden = true
                }
                
                if let messageToShow = DigitInput.messageToSend {
                    self.messageView.queueMessage(message: messageToShow)
                    DigitInput.messageToSend = nil
                }
                
                VirtualObjectInteraction.digitInput?.checkIfDigitInputIsEnabled(messageView: self.messageView)
                
                if let cubeNode = self.sceneView.scene.rootNode.childNode(withName: "cube", recursively: true) as? Cube {
                    print("cube = \(cubeNode.height)")
                    print("cube y = \(cubeNode.position.y)")
                }
                
                
                
                
            } else {
                self.focusSquare.hide()
            }
        }
    }
    
    /// When a plane is detected, make a planeNode for it.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Place content only for anchors found by plane detection
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        self.planeNode = Plane(anchor: planeAnchor)
        node.addChildNode(self.planeNode!)
    }
    
    /// When a detected plane is updated, make a new planeNode.
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        
        planeNode = Plane(anchor: planeAnchor)
        node.addChildNode(planeNode!)
    }
    
    /// When a detected plane is removed, remove the planeNode.
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {return}
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func disableTracking() {
        self.configuration.planeDetection = []
        self.sceneView.session.run(self.configuration)
        self.trackingDisabled = true
    }
    
}
