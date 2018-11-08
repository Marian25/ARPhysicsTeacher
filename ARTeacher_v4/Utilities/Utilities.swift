//
//  Utilities.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 24/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import ARKit

let normal = UIColor.white
let selected = UIColor(red: 70/255, green: 178/255, blue: 240/255, alpha: 1)

var tappingVirtualObjectsMode: TappingVirtualObjectsMode = .SelectObjectForInteraction

// MARK: - TappingVirtualObjectsMode
enum TappingVirtualObjectsMode {
    case AddingForceToObject
    case AddingRopeBetweenObjects
    case SelectObjectForInteraction
    case SimulationMode
}

enum Direction {
    case NONE
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

// MARK: - Collision categories
enum CollisionCategory: Int {
    case CollisionCategoryRamp = 1
    case CollisionCategoryCube = 2
}

// MARK: - float4x4 extensions

extension float4x4 {
    /**
    Treata matrix as a (right-hand column-major convention) transform matrix
    and factors out the translation component of the transform.
    */
    
    var translation: float3 {
        get {
            let translation = columns.3
            return float3(translation.x, translation.y, translation.z)
        }
        set(newValue) {
            columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }
    
    /**
     Factors out the orientation component of the transform.
     */
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
    
    /**
     Creates a tranform matrix with a uniform scale factor in all directions.
     */
    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.x = scale
        columns.2.x = scale
    }
}

// MARK: - CGPoint extensions

extension CGPoint {
    /// Extracts the screen space point from a vector returned by SCNView.projectPOint(_:).
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
    
    /// Returns the length of a point when considered as a vector. (Used with gesture recognizers.)
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
}

extension SCNVector3 {
    
    static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    static func !=(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return !(lhs == rhs)
    }
    
}

public func degToRadians(degrees: Double) -> Double {
    return degrees * (.pi / 180);
}

public func dist(_ a: SCNVector3, _ b: SCNVector3) -> Float {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2) + pow(a.z - b.z, 2))
}
