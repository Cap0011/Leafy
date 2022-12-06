//
//  OnboardingView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/12/06.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color("Background").ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                TabView(selection: $currentTab) {
                    OnboardingPage(notice: "리피와 함께 반려식물의\n성장과정을 기록해보세요", imageName: "Onboarding0")
                        .tag(0)
                    OnboardingPage(notice: "식물별 다양한 다이어리 커버를\n적용해보세요", imageName: "Onboarding1")
                        .tag(1)
                    OnboardingPage(notice: "식물별 관리 TIP을 확인하고\n식물케어를 해보세요", imageName: "Onboarding2")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                if currentTab == 2 {
                    startButton
                        .onTapGesture {
                            isOnboardingActive.toggle()
                        }
                } else {
                    startButton
                        .hidden()
                }
            }
            skipButton
                .onTapGesture {
                    isOnboardingActive.toggle()
                }
        }
        .font(.custom(FontManager.Pretendard.semiBold, size: 18))
    }
    
    var startButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("Black"))
                .frame(width: 130, height: 44)
            Text("시작하기")
                .foregroundColor(.white)
        }
        .padding(.top, 60)
        .padding(.bottom, 100)
    }
    
    var skipButton: some View {
        Text("Skip")
            .font(.custom(FontManager.Pretendard.medium, size: 15))
            .foregroundColor(Color("GreyText"))
            .padding(25)
    }
    
    struct OnboardingPage: View {
        let notice: String
        let imageName: String
        
        var body: some View {
            VStack(spacing: 80) {
                Text(notice)
                    .multilineTextAlignment(.center)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
