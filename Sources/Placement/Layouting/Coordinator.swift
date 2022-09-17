import Foundation
import SwiftUI

class PlacementsCoordinator: ObservableObject {
    var transaction = Transaction()
    var placements: [AnyHashable: LayoutPlacement] = [:]
}

class SizeCoordinator: ObservableObject {
    public var size: CGSize? = nil
    public var transaction = Transaction()
}

class Coordinator<L: PlacementLayout>: ObservableObject {
    var layout: L? = nil
    public var subviews: L.Subviews? = nil
    
    private var _cache: L.Cache?
    
    public var cache: L.Cache {
        get {
            return _cache!
        }
        set {
            _cache = newValue
        }
    }
        
    func layoutContext<T>(children: _VariadicView.Children, context: (L.Subviews, inout L.Cache) -> T) -> T {
        let subviews = makeSubviews(children: children)
        return context(subviews, &cache)
    }
    
    func makeSubviews(children: _VariadicView.Children) -> L.Subviews {
        if let subviews = subviews {
            let childrenIds = children.map { child in
                child.id
            }
            
            let subviewsIds = subviews.compactMap { subview in
                subview as? LayoutSubviewPolyfill
            }.map { subview in
                subview.id
            }
            
            if childrenIds == subviewsIds {
                return subviews
            }
        }
        
        let subviews = PlacementLayoutSubviews(subviews: children.map({ child in
            LayoutSubviewPolyfill(
                id: child.id,
                onPlacement: { placement in
                    self.placementsCoordinator.placements[child.id] = placement
                },
                getSizeThatFits: { size in
                    var hostingController: UIHostingController<AnyView> {
                        if let hostingController = self.hostingControllers[child.id] {
                            return hostingController
                        }
                        
                        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
                        self.hostingControllers[child.id] = hostingController
                        
                        return hostingController
                    }
                    
                    hostingController.rootView = AnyView(child)
                    hostingController._disableSafeArea = true
                    return hostingController.sizeThatFits(
                        in: size.replacingUnspecifiedDimensions(by: .zero)
                    )
                },
                spacing: .zero,
                child: child
            )
        }))
        
        let subviewsIds = subviews.compactMap { subview in
            subview as? LayoutSubviewPolyfill
        }.map { $0.id }
                
        self.hostingControllers = self.hostingControllers.filter { id, _ in
            subviewsIds.contains(id)
        }
        
        self.placementsCoordinator.placements = self.placementsCoordinator.placements.filter { id, _ in
            subviewsIds.contains(id)
        }
                
        if self._cache != nil {
            layout?.updateCache(&cache, subviews: subviews)
        } else {
            self._cache = layout?.makeCache(subviews: subviews)
        }
        
        self.subviews = subviews
        
        return subviews
    }
        
    public var transaction = Transaction()
    public var sizeCoordinator = SizeCoordinator()
    public var placementsCoordinator = PlacementsCoordinator()
    public var hostingControllers: [AnyHashable: UIHostingController<AnyView>] = [:]
}
