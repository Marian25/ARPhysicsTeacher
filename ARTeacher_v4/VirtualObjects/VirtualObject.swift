//
//  VirtualObject.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 04/03/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import SceneKit
import ARKit

enum MaterialsAvailable {
    case carvedLimeStoneGround
    case graniteSmooth
    case oakFloor2
    case oldTexturedFabric
    case rustedIronStreaks
    case sculptedFloorBoards
    case mahogFloor
}

class VirtualObject: SCNNode {
    
    var height: CGFloat = 0
    var identifier = 0
    
    static var numberVirtualObject = 0
    
    static func increaseVirtualObjectNumber() {
        VirtualObject.numberVirtualObject += 1
    }
    
    /// Use average of recent virtual object distances to avoid rapid changes in object scale.
    private var recentVirtualObjectDistances = [Float]()
    
    /// Allowed alignments for the virtual object
    var allowedAlignments: [ARPlaneAnchor.Alignment] {
        return [.horizontal]
    }
    
    /// Current alignment of the virtual object
    var currentAlignment: ARPlaneAnchor.Alignment = .horizontal
    
    /// Whether the object is currently changing alignment
    private var isChangingAlignment: Bool = false
    
    var rotationEnabled = false
    
    /// For correct rotation on horizontal and vertical surfaces, rotate around
    /// local y rather than world y. Therefore rotate first child node instead of self.
    var objectRotation: Float {
        get {
            return self.eulerAngles.y
        }
        set (newValue) {
            if rotationEnabled {
                var normalized = newValue.truncatingRemainder(dividingBy: 2 * .pi)
                normalized = (normalized + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
                
                if normalized > .pi {
                    normalized -= 2 * .pi
                }
                self.eulerAngles.y = normalized
                if currentAlignment == .horizontal {
                    rotationWhenAlignedHorizontally = normalized
                }
            }
        }
    }
    
    /// Remember the last rotation for horizontal alignment
    var rotationWhenAlignedHorizontally: Float = 0
    
    /// The object's corresponding ARAnchor
    var anchor: ARAnchor?
    
    override init() {
        super.init()
    }
    
    init(identifier: Int) {
        super.init()
        self.name = "virtual object"
        self.identifier = identifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTransform(_ newTransform: float4x4,
                      relativeTo cameraTranform: float4x4,
                      smoothMovement: Bool,
                      alignment: ARPlaneAnchor.Alignment,
                      allowAnimation: Bool,
                      overAnotherCubeObject: Bool,
                      cubeHeight: Float,
                      overAnotherRampObject: Bool,
                      rampCollisionHeight: Float,
                      rampAngle: Float) {
        
        let cameraWorldPosition = cameraTranform.translation
        var positionOffsetFromCamera = newTransform.translation - cameraWorldPosition
        
        // Limit the distance of the object from the camera to a maximum of 10 meters.
        if simd_length(positionOffsetFromCamera) > 10 {
            positionOffsetFromCamera = simd_normalize(positionOffsetFromCamera)
            positionOffsetFromCamera *= 10
        }
        
        simdPosition = cameraWorldPosition + positionOffsetFromCamera
        simdPosition.y += Float(height * 0.5)
        
        if overAnotherCubeObject == true {
            print("virtual object overAnotherCubeObject")
            simdPosition.y += cubeHeight
        }
        
        if overAnotherRampObject == true {
            print("virtual object overAnotherRampObject")
            self.eulerAngles.z = rampAngle * .pi / 180.0
            simdPosition.y += rampCollisionHeight
        } else {
            self.eulerAngles.z = 0
        }
        
//        updateAlignment(to: alignment, transform: newTransform, allowAnimation: allowAnimation)
    }
    
    // MARK: - Setting the object's alignment
    
    func updateAlignment(to newAlignment: ARPlaneAnchor.Alignment, transform: float4x4, allowAnimation: Bool) {
        
        if isChangingAlignment {
            return
        }
        
        // Only animate if the alignment has changed.
        let animationDuration = (newAlignment != currentAlignment && allowAnimation) ? 0.5 : 0
        
        var newObjectRotation: Float?
        if newAlignment == .horizontal && currentAlignment == .vertical {
            // When changing to horizontal placement, restore the previous horizontal rotation.
            newObjectRotation = rotationWhenAlignedHorizontally
        } else if newAlignment == .vertical && currentAlignment == .horizontal {
            // When changing to vertical placement, reset the object's rotation (y-up).
            newObjectRotation = 0.0001
        }
        
        currentAlignment = newAlignment
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = animationDuration
        SCNTransaction.completionBlock = {
            self.isChangingAlignment = false
        }
        
        isChangingAlignment = true
        
        // Use the filtered position rather than the exact one from the transform
        simdTransform.translation = simdWorldPosition
        
        if newObjectRotation != nil {
            objectRotation = newObjectRotation!
        }
        
        SCNTransaction.commit()
    }
    
    static func setupMaterial(materialAvailable: MaterialsAvailable) -> SCNMaterial {
        let materialName = chooseMaterial(materialAvailable: materialAvailable)
        let imagesPath = "art.scnassets/Materials/\(materialName)/\(materialName)"
        
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIImage(named: imagesPath + "-albedo.png")
        material.roughness.contents = UIImage(named: imagesPath + "-roughness.png")
        material.metalness.contents = UIImage(named: imagesPath + "-metal.png")
        material.normal.contents = UIImage(named: imagesPath + "-normal.png")
        
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.roughness.wrapS = .repeat
        material.roughness.wrapT = .repeat
        material.metalness.wrapS = .repeat
        material.metalness.wrapT = .repeat
        material.normal.wrapS = .repeat
        material.normal.wrapT = .repeat
        
        return material
    }
    
    static func chooseMaterial(materialAvailable: MaterialsAvailable) -> String {
        switch materialAvailable {
        case .carvedLimeStoneGround:
            return "carvedlimestoneground"
        case .graniteSmooth:
            return "granitesmooth"
        case .oakFloor2:
            return "oakfloor2"
        case .oldTexturedFabric:
            return "old-textured-fabric"
        case .rustedIronStreaks:
            return "rustediron-streaks"
        case .sculptedFloorBoards:
            return "sculptedfloorboards"
        case .mahogFloor:
            return "mahogfloor"
        }
    }
    
    
    /// Returns a 'VirtualObject' if one exists as an ancestor to the provided node.
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        
        if let virtualObjectRoot = node as? VirtualObject {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a 'VirtualObject'.
        return existingObjectContainingNode(parent)
    }
    
    func updateVariables(value: CGFloat, measureUnit: String) {
        print("Virtual Object update variables")
    }
    
    func showVariables() {
        
    }
    
}


extension Collection where Element == Float, Index == Int {
    
    /// Return the mean of a list of Floats. Used with 'recentVirtualObjectDistances'.
    var average: Float? {
        guard !isEmpty else {
            return nil
        }
        
        let sum = reduce(Float(0)) {
            (current, next) -> Float in
            return current + next
        }
        
        return sum / Float(count)
    }
    
}



