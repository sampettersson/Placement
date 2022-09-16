import Foundation
import UIKit

class ZeroSizeView: UIView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
