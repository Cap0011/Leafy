//
//  PlantingTipView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/04.
//

import SwiftUI

struct PlantingTipView: View {
    let contentsNumber: Int
    
    @State var plantName = ""
    
    @State var temperature = ""
    @State var humidity = ""
    @State var sunlight = ""
    @State var fertiliser = ""
    @State var waterSpring = ""
    @State var waterSummer = ""
    @State var waterAutumn = ""
    @State var waterWinter = ""
    
    @State var isLoading = true
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(Color("Unselected"))
                .frame(width: 50, height: 4)
                .padding(.top, 12)
            Text("\(plantName) 관리 TIP")
                .foregroundColor(Color("Black"))
                .padding(.horizontal, 12)
                .font(.custom(FontManager.Pretendard.medium, size: 13))
                .padding(.top, 35)
                .padding(.bottom, 10)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if isLoading {
                        HStack {
                            Spacer()
                            ActivityIndicatorView()
                                .padding(.vertical, 14)
                            Spacer()
                        }
                        .padding(.top, 80)
                        
                        Spacer()
                    } else {
                        HStack(spacing: 16) {
                            InfoCardView(iconImage: Image(systemName: "thermometer"), color: Color("Temperature"), title: "생육 온도", info: temperature)
                            InfoCardView(iconImage: Image(systemName: "humidity.fill"), color: Color("Humidity"), title: "습도", info: humidity)
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
                            .padding(16)
                        }
                        .frame(height: 220)
                        Spacer()
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 24)
                .task {
                    if contentsNumber >= 0 {
                        let dataStore = PlantDataStore.shared
                        try? await dataStore.loadPlantData(contentsNumber: contentsNumber)
                        plantName = dataStore.plantName
                        temperature = dataStore.temperature
                        humidity = dataStore.humidity
                        sunlight = dataStore.light
                        fertiliser = dataStore.fertiliser
                        waterSpring = Constant.waterCycleString(code: Int(dataStore.springWater) ?? 0)
                        waterSummer = Constant.waterCycleString(code: Int(dataStore.summerWater) ?? 0)
                        waterAutumn = Constant.waterCycleString(code: Int(dataStore.autumnWater) ?? 0)
                        waterWinter = Constant.waterCycleString(code: Int(dataStore.winterWater) ?? 0)
                        isLoading = false
                    } else {
                        isLoading = false
                    }
                }
            }
        }
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
                Divider()
                Text(info)
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
                    .foregroundColor(Color("Black"))
            }
            .lineSpacing(4)
            .padding(16)
        }
    }
}

struct PlantingTipView_Previews: PreviewProvider {
    static var previews: some View {
        PlantingTipView(contentsNumber: 14663)
    }
}
