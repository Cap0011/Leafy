//
//  View.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/11/24.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}
