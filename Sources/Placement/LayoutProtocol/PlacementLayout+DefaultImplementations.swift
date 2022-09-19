//
//  PlacementLayout+DefaultImplementations.swift
//  PlacementTests
//
//  Created by Sam Pettersson on 2022-09-19.
//

import Foundation
import SwiftUI

extension PlacementLayout {
    public func updateCache(_ cache: inout Cache, subviews: Subviews) {}
    
    public func spacing(subviews: Subviews, cache: inout Cache) -> PlacementViewSpacing {
        PlacementViewSpacing()
    }
    
    public func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGFloat? {
        return nil
    }
    
    public var prefersLayoutProtocol: Bool {
        true
    }
    
    public var disablesAnimationsWhenPlacing: Bool {
        false
    }
    
    public static var layoutProperties: PlacementLayoutProperties {
        PlacementLayoutProperties()
    }
}

extension PlacementLayout where Cache == Void {
    public func makeCache(subviews: Subviews) -> Cache {
        return ()
    }
}
