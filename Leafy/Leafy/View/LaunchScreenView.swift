//
//  LaunchScreenView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/12/06.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    
    var body: some View {
        if isActive && isOnboardingActive {
            OnboardingView()
        } else if !isOnboardingActive {
            MainView()
        } else if !isActive {
            ZStack {
                Color("LaunchBackground").ignoresSafeArea()
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.isActive = true
                        }
                    }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
