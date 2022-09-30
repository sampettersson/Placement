import Foundation
import SwiftUI

class PlacementsCoordinator: ObservableObject {
    var placements: [AnyHashable: LayoutPlacement] = [:]
}

class Coordinator<L: PlacementLayout>: ObservableObject {
    var globalFrame: CGRect? = nil
    var layoutProxy: GeometryProxy? = nil {
        didSet {
            globalFrame = layoutProxy?.frame(in: .global)
        }
    }
    var layout: L? = nil
    public var subviews: PlacementLayoutSubviews? = nil
    
    private var _cache: L.Cache?
    
    public var cache: L.Cache {
        get {
            return _cache!
        }
        set {
            _cache = newValue
        }
    }
    
    func placeSubviews(children: _VariadicView.Children) {
        guard let globalFrame = globalFrame else {
            return
        }
        
        layoutContext(children: children) { subviews, cache in
            let proposal = PlacementProposedViewSize(globalFrame.size)
                                    
            layout?.placeSubviews(
                in: globalFrame,
                proposal: proposal,
                subviews: subviews,
                cache: &cache
            )
                                    
            if #available(iOS 16, *) {
                DispatchQueue.main.async {
                    withTransaction(self.transaction) {
                        self.placementsCoordinator.objectWillChange.send()
                    }
                }
            } else {
                withTransaction(transaction) {
                    placementsCoordinator.objectWillChange.send()
                }
            }
        }
    }
            
    func layoutContext<T>(children: _VariadicView.Children, context: (PlacementLayoutSubviews, inout L.Cache) -> T) -> T {
        let subviews = makeSubviews(children: children)
        return context(subviews, &cache)
    }
    
    func makeSubviews(children: _VariadicView.Children) -> PlacementLayoutSubviews {
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
                    DispatchQueue.main.async {
                        self.hostingControllers[child.id]?.view.frame = CGRect(
                            origin: placement.position,
                            size: placement.proposal.replacingUnspecifiedDimensions(by: .zero)
                        )
                    }
                    
                    self.placementsCoordinator.placements[child.id] = LayoutPlacement(
                        subview: placement.subview,
                        position: CGPoint(
                            x: placement.position.x,
                            y: placement.position.y
                        ),
                        anchor: placement.anchor,
                        proposal: placement.proposal
                    )
                },
                getSizeThatFits: { size in
                    let hostingController = self.makeHostingController(id: child.id)
                    hostingController.rootView = AnyView(child)
                    hostingController._disableSafeArea = true
                                        
                    let sizeThatFits = hostingController.sizeThatFits(
                        in: size.replacingUnspecifiedDimensions(by: .zero)
                    )
                    
                    return sizeThatFits
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
    
    func makeHostingController(id: AnyHashable) -> UIHostingController<AnyView> {
        if let hostingController = self.hostingControllers[id] {
            return hostingController
        }
        
        let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        self.hostingControllers[id] = hostingController
        
        return hostingController
    }
        
    public var transaction = Transaction()
    public var placementsCoordinator = PlacementsCoordinator()
    public var hostingControllers: [AnyHashable: UIHostingController<AnyView>] = [:]
}
