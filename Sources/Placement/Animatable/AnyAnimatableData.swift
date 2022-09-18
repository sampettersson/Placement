//
//  AnyAnimatableData.swift
//  PlacementDemo
//
//  Created by Sam Pettersson on 2022-09-18.
//

import Foundation
import SwiftUI

public struct AnyAnimatableData: VectorArithmetic {
    var _equals: (_ self: Self, _ other: AnyAnimatableData) -> Bool
    var _plusEquals: (_ self: Self, _ other: AnyAnimatableData) -> AnyAnimatableData
    var _minusEquals: (_ self: Self, _ other: AnyAnimatableData) -> AnyAnimatableData
    
    public static func == (lhs: AnyAnimatableData, rhs: AnyAnimatableData) -> Bool {
        return lhs._equals(lhs, rhs)
    }
    
    public static func += (lhs: inout AnyAnimatableData, rhs: AnyAnimatableData) {
        lhs.vector = lhs._plusEquals(lhs, rhs).vector
    }
    
    public static func -= (lhs: inout AnyAnimatableData, rhs: AnyAnimatableData) {
        lhs.vector = lhs._minusEquals(lhs, rhs).vector
    }
    
    public static func + (lhs: AnyAnimatableData, rhs: AnyAnimatableData) -> AnyAnimatableData {
        var ret = lhs
        ret += rhs
        return ret
    }
    
    public static func - (lhs: AnyAnimatableData, rhs: AnyAnimatableData) -> AnyAnimatableData {
        var ret = lhs
        ret -= rhs
        return ret
    }
    
    var vector: any VectorArithmetic
    
    public mutating func scale(by rhs: Double) {
        vector.scale(by: rhs)
    }
    
    public var magnitudeSquared: Double {
        vector.magnitudeSquared
    }
    
    public static var zero: AnyAnimatableData {
        AnyAnimatableData(EmptyAnimatableData.zero)
    }
    
    init<V: VectorArithmetic>(
        _ vector: V
    ) {
        self.vector = vector
        self._equals = { anyAnimatable, other in
            (anyAnimatable.vector as? V) == (other.vector as? V)
        }
        self._plusEquals = { anyAnimatable, other in
            if let vector = anyAnimatable.vector as? V, let otherVector = other.vector as? V {
                return AnyAnimatableData(vector + otherVector)
            }
            
            return anyAnimatable
        }
        self._minusEquals = { anyAnimatable, other in
            if let vector = anyAnimatable.vector as? V, let otherVector = other.vector as? V {
                return AnyAnimatableData(vector - otherVector)
            }
            
            return anyAnimatable
        }
    }
}
