//
//  VirtualObjectInteraction.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 07/03/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import ARKit
import DigitInputView

class VirtualObjectInteraction: NSObject, UIGestureRecognizerDelegate {
    
    /// Developer setting to translate assuming the detected plane extends infinitely.
    let translateAssumingInfinitePlane = true
    
    /// The scene view to hit test against when moving virtual content.
    let sceneView: ARSCNView
    
    /// View to introduce values of different measurement variables
    static var digitInput: DigitInput?
    
    /**
     The object that  has been most recently interacted with.
     The 'selectedObject' can be moved at any time with the tap gesture.
     */
    var selectedObject: VirtualObject?
    
    var currentCubeSelectedForAddingForce: Cube?
    
    /// The object that user want to apply force
    var tappedToAddForceObject: VirtualObject?
    
    /// The object that is tracked for use by the pan and rotation gestures.
    private var trackedObject: VirtualObject? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    
    /// The tracked screen position used to update the 'trackedObject''s position in 'updateObjectToCurrentTrackingPosition()'.
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        
        let panGesture = ThresholdPanGesture(target: self, action: #selector(didPan))
        panGesture.delegate = self

        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate))
        rotationGesture.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.delegate = self
        
        sceneView.addGestureRecognizer(panGesture)
        sceneView.addGestureRecognizer(rotationGesture)
        sceneView.addGestureRecognizer(tapGesture)
        
        VirtualObjectInteraction.digitInput = DigitInput(sceneView: self.sceneView, virtualObjectInteraction: self)
    }
    
    var overAnotherCubeObject = false
    var overAnotherObjectCubeArray = [Bool]()
    
    var overAnotherRampObject = false
    var overAnotherObjectRampArray = [Bool]()
    
    var cubeHeight: Float = 0
    
    var rampCollisionHeight: Float = 0
    var rampAngle: Float = 0
    var ropeAdded = false
    var ropeFinished = false
    var lastRingsInteractivity = 5
    
    var firstObjectIdentifier = 0
    
    var ropeDirection: Direction = .NONE
    var consecutiveSameDirectionOccured = 1
    let consecutiveSameDirectionThreshold = 3
    
    var currentForceDirection: Direction = .NONE
    
    @objc func didPan(_ gesture: ThresholdPanGesture) {
        switch gesture.state {
        case .began:
            // Check for interaction with a new object.
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
        case .changed where gesture.isThresholdExceeded:
            guard let object = trackedObject else { return }
            let translation = gesture.translation(in: sceneView)
            
            if tappingVirtualObjectsMode == .AddingRopeBetweenObjects && (translation.x != 0 || translation.y != 0) {
                
               ropeDirection = chooseRopeDirection(translation: translation, ropeDirection: ropeDirection)
                
                print("rope direction = \(ropeDirection)")
//                print("consecutive same direction occured = \(consecutiveSameDirectionOccured)")
                print("rope added = \(ropeAdded)")
                print("rope finished = \(ropeFinished)")
                
                // test translation multiples times to determine direction
//                if consecutiveSameDirectionOccured > consecutiveSameDirectionThreshold {
//                    consecutiveSameDirectionOccured = 1
//
                    // if object interacting is a cube we add first ring of rope
                    if object.name == "cube" && ropeAdded == false && ropeFinished == false {
                        print("init rope is called -> we have first cube from rope")
                        
                        self.firstObjectIdentifier = object.identifier
                        Rope.initRope(direction: ropeDirection, attachNode: object, scene: sceneView.scene)
                        
                        // adding multiple rings
                        for _ in 0..<lastRingsInteractivity {
                            Rope.addRing(scene: sceneView.scene)
                        }
                        
                        ropeAdded = true
                    } else if ropeAdded == true && ropeFinished == false {  // 
                        
                        if let object = objectInteracting(with: gesture, in: sceneView) {
                            print("first object identifier = \(self.firstObjectIdentifier)")
                            print("current object identifier = \(object.identifier)")
                            
                            if object.name == "ring" || object.name == "plane" {
                                guard let ringNode = object as? Ring else { return }
                                
                                if ringNode.identifierInRope > Rope.chainRings.count - lastRingsInteractivity {
                                    print("still panning -> adding another cube to rope")
                                    for _ in 0..<lastRingsInteractivity {
                                        Rope.addRing(scene: sceneView.scene)
                                    }
                                }
                            } else if object.name == "cube" && object.identifier != self.firstObjectIdentifier {
                                print("second object occured -> finished rope is true")
                                Rope.attachSecondObject(scene: sceneView.scene, attachNode: object)
                                ropeFinished = true
                            }
                        }
                        
                    }
//                }
            } else if tappingVirtualObjectsMode == .SelectObjectForInteraction {
                let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(object.position))
                
                // The 'currentTrackingPosition' is used to update the 'selectedObject' in 'updateObjectToCurrentTrackingPosition()'
                currentTrackingPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
                
                self.checkCollisionWithCube(of: object)
                self.checkCollisionWithRamp(of: object)
                
                gesture.setTranslation(.zero, in: sceneView)
            }
        case .changed:
            // Ignore changes to the pan gesture until the threshold for displacement has been exceeded.
            break
        case .ended:
            if tappingVirtualObjectsMode == .AddingRopeBetweenObjects {
                // if rope is not finished remove the rings previous added
                if ropeFinished == false {
                    Rope.removeRope(scene: sceneView.scene)
                    ropeAdded = false
                }
            } else {
                guard let existingTrackedObject = trackedObject else { return }
                sceneView.addOrUpdateAnchor(for: existingTrackedObject)
            }
            fallthrough
        default:
            // Clear the current position tracking.
            currentTrackingPosition = nil
            trackedObject = nil
        }
        
    }
    
    func chooseRopeDirection(translation: CGPoint, ropeDirection: Direction) -> Direction {
        
        if translation.x > 0 && abs(translation.x) > abs(translation.y) {
            if ropeDirection == .RIGHT {
                consecutiveSameDirectionOccured += 1
            } else {
                consecutiveSameDirectionOccured = 1
            }
            
            return .RIGHT
        } else if translation.x < 0 && abs(translation.x) > abs(translation.y)  {
            if ropeDirection == .LEFT {
                consecutiveSameDirectionOccured += 1
            } else {
                consecutiveSameDirectionOccured = 1
            }
            
            return .LEFT
        } else if translation.y < 0 {
            if ropeDirection == .UP {
                consecutiveSameDirectionOccured += 1
            } else {
                consecutiveSameDirectionOccured = 1
            }
            
            return .UP
        }
        
        return .NONE
    }
    
    func updateForceDirection(direction: Direction) {
        self.currentForceDirection = direction
        currentCubeSelectedForAddingForce?.addForce(forceDirection: direction)
    }
    
    func checkCollisionWithCube(of object: VirtualObject) {
        /// Check collisions with cubes
        var overCubeObject = false
        let listCubeNode = self.checkForInteractionWhilePanning(typeOfOjectsInteracting: ["cube"]) as! [Cube]
        
        for cube in listCubeNode {
            if cube.position != object.position {
                overCubeObject = overCubeObject || self.checkCollision(a: cube.position, b: object.position, sizeA: Float(cube.height), sizeB: Float(object.height), rampAngle: nil)
            }
        }
        
        overAnotherObjectCubeArray.append(overCubeObject)
        
        if overAnotherObjectCubeArray.count == 10 {
            self.overAnotherCubeObject = overAnotherObjectCubeArray[0]
            for overAnotherCubeObject in overAnotherObjectCubeArray {
                self.overAnotherCubeObject = self.overAnotherCubeObject || overAnotherCubeObject
            }
            
            overAnotherObjectCubeArray = []
        }
    }
    
    func checkCollisionWithRamp(of object: VirtualObject) {
        /// Check collsion with ramps
        var overRampObject = false
        let listRampNode = self.checkForInteractionWhilePanning(typeOfOjectsInteracting: ["ramp"]) as! [Ramp]
        
        for ramp in listRampNode {
            if ramp.position != object.position {
                overRampObject = overRampObject || self.checkCollision(a: ramp.position, b: object.position, sizeA: Float(ramp.size), sizeB: Float(object.height), rampAngle: ramp.planeAngle)
            }
        }
        
        overAnotherObjectRampArray.append(overRampObject)
        
        if overAnotherObjectRampArray.count == 10 {
            self.overAnotherRampObject = overAnotherObjectRampArray[0]
            for overAnotherRampObject in overAnotherObjectRampArray {
                self.overAnotherRampObject = self.overAnotherRampObject || overAnotherRampObject
            }
            
            if let cubeNode = object as? Cube {
                if self.overAnotherRampObject == true {
                    if let rampNode = listRampNode.first {
                        cubeNode.cubeAngle = rampNode.planeAngle
                    }
                } else {
                    cubeNode.cubeAngle = 0
                }
            }
            
            overAnotherObjectRampArray = []
        }
    }
    
    func checkCollision(a: SCNVector3, b: SCNVector3, sizeA: Float, sizeB: Float, rampAngle: CGFloat?) -> Bool{
        
        if(abs(a.x - b.x) < sizeA / 2 + sizeB / 2) {
            if(abs(a.z - b.z) < sizeA / 2 + sizeB / 2) {
                if let angle = rampAngle {
                    
                    let dist = sqrt(pow(a.x - b.x + sizeA * 0.5, 2) + pow(a.z - b.z, 2))
                    let d = sizeA - dist
                    
                    self.rampAngle = Float(angle)
                    self.rampCollisionHeight = Float(tan((angle) * .pi / 180.0)) * d
                } else {
                    self.cubeHeight = sizeA
                }
                return true
            }
        }
        
        self.cubeHeight = 0
        self.rampCollisionHeight = 0
        return false
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        
        if let tappedObject = sceneView.virtualObject(at: touchLocation) {
            if tappingVirtualObjectsMode == .SelectObjectForInteraction {
                selectedObject = tappedObject
            } else if tappingVirtualObjectsMode == .AddingForceToObject {
                guard let cubeTappedObject = tappedObject as? Cube else { return }
                
                VirtualObjectInteraction.digitInput?.showDigitInput(measureUnit: "N", parentNode: tappedObject)
                currentCubeSelectedForAddingForce = cubeTappedObject

            } else if tappingVirtualObjectsMode == .AddingRopeBetweenObjects {
                
            }
            
        } else if let object = selectedObject {
            translate(object, basedOn: touchLocation, infinitePlane: false, allowAnimation: false)
            sceneView.addOrUpdateAnchor(for: object)
        }
    }
    
    func updateObjectToCurrentTrackingPosition() {
        guard let object = trackedObject, let position = currentTrackingPosition else { return }
        translate(object, basedOn: position, infinitePlane: translateAssumingInfinitePlane, allowAnimation: true)
    }
    
    /// Tag: - didRotate
    @objc func didRotate(gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        
        /*
         - Note:
                For looking down on the object (99% of all use case), we need to substract the angle. To make rotation also work correctly when looking from below the object one would have to flip the sign of the angle depending on whether the object is above or below the camera...
         */
        trackedObject?.objectRotation -= Float(gesture.rotation)
        
        // trying to rotate text when parent object is rotating - still not working
        if let trackedObject = trackedObject {
            self.applyRotationForAllChildren(for: trackedObject, rotation: gesture.rotation)
        }
        
        gesture.rotation = 0
    }
    
    func applyRotationForAllChildren(for node: VirtualObject, rotation: CGFloat) {
        if node.childNodes.count > 0 {
            for child in node.childNodes {
                if let child = child as? VirtualObject {
                    child.objectRotation -= Float(rotation)
                    applyRotationForAllChildren(for: child, rotation: rotation)
                }
            }
        }
        
    }
    
    func checkForInteractionWhilePanning(typeOfOjectsInteracting: [String]?) -> [SCNNode] {
        let rootNode = sceneView.scene.rootNode
        var listNode = [SCNNode]()
        
        transformTreeNodeToListNode(root: rootNode, typeOfOjectsInteracting: typeOfOjectsInteracting, listNode: &listNode)
        
        return listNode
    }
    
    func transformTreeNodeToListNode(root: SCNNode, typeOfOjectsInteracting: [String]?, listNode: inout [SCNNode]) {
        
        for child in root.childNodes {
            if let typeOfObjects = typeOfOjectsInteracting,
                let childName = child.name {
                
                if typeOfObjects.contains(childName) {
                    listNode.append(child)
                    transformTreeNodeToListNode(root: child, typeOfOjectsInteracting: typeOfOjectsInteracting, listNode: &listNode)
                }
            }
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow objects to be translated and rotated at the same time.
        return true
    }
    
    /// A helper method to return the first object that is found under the provided 'gesture''s touch locations.
    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> VirtualObject? {
        
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            // Look for an object directly under the touchLocation
            if let object = sceneView.virtualObject(at: touchLocation) {
                return object
            }
        }
        
        // As a last resort look for an object under the center of the touches.
//        return sceneView.virtualObject(at: gesture.center(in: view))
        return nil
    }
    
    // MARK: - Update object position
    
    /// - Tag: DragVirtualObject
    private func translate(_ object: VirtualObject, basedOn screenPos: CGPoint, infinitePlane: Bool, allowAnimation: Bool) {
        if tappingVirtualObjectsMode == .SelectObjectForInteraction {
            guard let cameraTransform = sceneView.session.currentFrame?.camera.transform,
                let result = sceneView.smartHitTest(screenPos,
                                                    infinitePlane: infinitePlane,
                                                    objectPosition: object.simdWorldPosition,
                                                    allowedAlignments: object.allowedAlignments) else { return }

            let planeAlignment: ARPlaneAnchor.Alignment
            if let planeAnchor = result.anchor as? ARPlaneAnchor {
                planeAlignment = planeAnchor.alignment
            } else if result.type == .estimatedHorizontalPlane {
                planeAlignment = .horizontal
            } else if result.type == .estimatedVerticalPlane {
                planeAlignment = .vertical
            } else {
                return
            }

            /*
             Plane hit test results are generally smooth. If we did *not* hit a plane,
             smooth the movement to prevent large jumps.
             */
            let transform = result.worldTransform
            let isOnPlane = result.anchor is ARPlaneAnchor
            object.setTransform(transform,
                                relativeTo: cameraTransform,
                                smoothMovement: !isOnPlane,
                                alignment: planeAlignment,
                                allowAnimation: allowAnimation,
                                overAnotherCubeObject: overAnotherCubeObject,
                                cubeHeight: cubeHeight,
                                overAnotherRampObject: overAnotherRampObject,
                                rampCollisionHeight: rampCollisionHeight,
                                rampAngle: rampAngle)
        }
        
//        if tappingVirtualObjectsMode == .AddingRopeBetweenObjects {
//            let hitResults = sceneView.hitTest(screenPos, options: nil)
//
//            if let result = hitResults.first {
//                if result.node.name == "ring" {
//                    print("still on ring")
//                } else {
//                    print("outside of the ring")
//                }
//            }
//
//        }
        
    }

}

extension UIGestureRecognizer {
    
    func center(in view: UIView) -> CGPoint {
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)
        
        let touchBounds = (1..<numberOfTouches).reduce(first) {
            touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }
        
        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
    
}
