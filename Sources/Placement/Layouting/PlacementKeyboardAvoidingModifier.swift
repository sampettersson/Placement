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

struct KeyboardAvoidingView<L: PlacementLayout>: UIViewRepresentable {
    @Environment(\.placementShouldAdjustToKeyboard) var placementShouldAdjustToKeyboard
    @EnvironmentObject var coordinator: Coordinator<L>
    @Binding var keyboardFrame: CGRect
    
    class KeyboardCoordinator {
        var shouldAdjust: Bool
        var coordinator: Coordinator<L>
        @Binding var keyboardFrame: CGRect
        
        init(
            shouldAdjust: Bool,
            coordinator: Coordinator<L>,
            keyboardFrame: Binding<CGRect>
        ) {
            self.shouldAdjust = shouldAdjust
            self.coordinator = coordinator
            self._keyboardFrame = keyboardFrame
            
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(
                self,
                selector: #selector(handleKeyboardHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
            notificationCenter.addObserver(
                self,
                selector: #selector(handleKeyboardFrame),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )
            notificationCenter.addObserver(
                self,
                selector: #selector(handleKeyboardFrame),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        }
        
        @objc func handleKeyboardHide(notification: Notification) {
            if shouldAdjust {
                withAnimation(keyboardAnimation(from: notification)) {
                    coordinator.keyboardFrame = .zero
                    self.keyboardFrame = .zero
                }
            }
        }
        
        @objc func handleKeyboardFrame(notification: Notification) {
            let keyboardFrame = (
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            ) ?? .zero
            
            if shouldAdjust && coordinator.keyboardFrame != keyboardFrame {
                coordinator.keyboardFrame = keyboardFrame
                
                withAnimation(keyboardAnimation(from: notification)) {
                    self.keyboardFrame = keyboardFrame
                }
            }
        }
    }
    
    func makeCoordinator() -> KeyboardCoordinator {
        Coordinator(
            shouldAdjust: placementShouldAdjustToKeyboard,
            coordinator: coordinator,
            keyboardFrame: $keyboardFrame
        )
    }
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.shouldAdjust = placementShouldAdjustToKeyboard
        context.coordinator.coordinator = coordinator
    }
}

struct PlacementKeyboardAvoidingModifier<L: PlacementLayout>: ViewModifier {
    @Environment(\.placementShouldAdjustToKeyboard) var placementShouldAdjustToKeyboard
    @EnvironmentObject var coordinator: Coordinator<L>
    @Binding var keyboardFrame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(KeyboardAvoidingView<L>(keyboardFrame: $keyboardFrame))
    }
}
