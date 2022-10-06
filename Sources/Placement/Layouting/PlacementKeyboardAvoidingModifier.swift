//
//  PlacementKeyboardAvoidingModifier.swift
//  Placement
//
//  Created by Sam Pettersson on 2022-10-06.
//

import Foundation
import SwiftUI

func keyboardAnimation(from notification: Notification) -> Animation? {
    guard
      let info = notification.userInfo,
      let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
      let uiKitCurve = UIView.AnimationCurve(rawValue: curveValue)
    else {
        return nil
    }
    
    let timing = UICubicTimingParameters(animationCurve: uiKitCurve)
    return Animation.timingCurve(
        Double(timing.controlPoint1.x),
        Double(timing.controlPoint1.y),
        Double(timing.controlPoint2.x),
        Double(timing.controlPoint2.y),
        duration: duration
    )
}

struct PlacementKeyboardAvoidingModifier<L: PlacementLayout>: ViewModifier {
    @Environment(\.placementShouldAdjustToKeyboard) var placementShouldAdjustToKeyboard
    @EnvironmentObject var coordinator: Coordinator<L>
    @Binding var keyboardFrame: CGRect
    
    func body(content: Content) -> some View {
        content
        .onAppear()
        .onReceive(
            NotificationCenter.Publisher(
                center: NotificationCenter.default,
                name: UIResponder.keyboardWillChangeFrameNotification
            )
            .merge(
                with:
                    NotificationCenter.Publisher(
                        center: NotificationCenter.default,
                        name: UIResponder.keyboardWillShowNotification
                    )
            )
            .removeDuplicates(by: { lhs, rhs in
                lhs.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect !=
                rhs.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            })
        )
        { notification in
            let keyboardFrame = (
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            ) ?? .zero
            
            if placementShouldAdjustToKeyboard {
                if coordinator.globalFrame?.contains(keyboardFrame.origin) ?? false {
                    withAnimation(keyboardAnimation(from: notification)) {
                        coordinator.keyboardFrame = keyboardFrame
                        self.keyboardFrame = keyboardFrame
                    }
                }
            }
        }
        .onReceive(
            NotificationCenter.Publisher(
                center: NotificationCenter.default,
                name: UIResponder.keyboardWillHideNotification
            )
        )
        { notification in
            withAnimation(keyboardAnimation(from: notification)) {
                coordinator.keyboardFrame = .zero
                self.keyboardFrame = .zero
            }
        }
    }
}
