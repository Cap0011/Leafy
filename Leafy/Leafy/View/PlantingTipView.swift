//
//  PlantingTipView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/04.
//

import SwiftUI

struct PlantingTipView: View {
    let temperature = "16~20°C"
    let humidity = "40~70%"
    let sunlight = "낮음, 중간, 높음"
    let fertiliser = "보통 요구함"
    let waterSpring = "토양 표면이 말랐을때 충분히 관수함"
    let waterSummer = "토양 표면이 말랐을때 충분히 관수함"
    let waterAutumn = "토양 표면이 말랐을때 충분히 관수함"
    let waterWinter = "흙을 촉촉하게 유지함(물에 잠기지 않도록 주의)"
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(Color("Unselected"))
                .frame(width: 50, height: 4)
                .padding(.bottom, 16)
                .padding(.top, 12)
            
            HStack(spacing: 16) {
                InfoCardView(iconImage: Image(systemName: "thermometer"), color: Color("Temperature"), title: "생육 온도", info: temperature)
                InfoCardView(iconImage: Image(systemName: "humidity.fill"), color: Color("Water"), title: "습도", info: humidity)
            }
            HStack(spacing: 16) {
                InfoCardView(iconImage: Image(systemName: "sun.max.fill"), color: Color("Sun"), title: "필요 광도", info: sunlight)
                InfoCardView(iconImage: Image("Fertiliser-selected"), color: .black, title: "비료", info: fertiliser)
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color("SearchbarBackground"))
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(Color("Water"))
                        .padding(.bottom, 8)
                    Text("물주기")
                        .font(.custom(FontManager.Pretendard.medium, size: 13))
                        .foregroundColor(Color("GreyText"))
                    Rectangle()
                        .foregroundColor(Color("Unselected"))
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("봄")
                            Text("여름")
                            Text("가을")
                            Text("겨울")
                        }
                        .foregroundColor(Color("GreyText"))
                        VStack(alignment: .leading, spacing: 8) {
                            Text(waterSpring)
                            Text(waterSummer)
                            Text(waterAutumn)
                            Text(waterWinter)
                        }
                        .foregroundColor(Color("Black"))
                        .padding(.trailing, -24)
                    }
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
                }
                .padding(24)
            }
            .frame(height: 220)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct InfoCardView: View {
    let iconImage: Image
    let color: Color
    let title: String
    let info: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("SearchbarBackground"))
            VStack(alignment: .leading, spacing: 8) {
                iconImage
                    .foregroundColor(color)
                Text(title)
                    .font(.custom(FontManager.Pretendard.medium, size: 13))
                    .foregroundColor(Color("GreyText"))
                Text(info)
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
                    .foregroundColor(Color("Black"))
            }
            .padding(24)
        }
        .frame(height: 120)
    }
}

struct PlantingTipView_Previews: PreviewProvider {
    static var previews: some View {
        PlantingTipView()
    }
}
