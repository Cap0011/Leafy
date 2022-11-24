//
//  PlantData.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import SwiftUI

class Plant: Identifiable {
    init() {
        
    }
    
    init(nickname: String, info: PlantInfo?, journals: [Journal], diaryStyle: DiaryStyle) {
        self.nickname = nickname
        self.info = info
        self.journals = journals
        self.diaryStyle = diaryStyle
    }
    
    var nickname = ""
    var info: PlantInfo?
    var journals = [Journal]()
    var diaryStyle: DiaryStyle?
}

extension Plant {
    static let flower = Plant(nickname: "백백이", info: PlantInfo(contentNo: 14663, plantName: "동백", humidity: "70%", fertiliser: "비료 필요", springWater: "자주", summerWater: "흙 촉촉", autumnWater: "흙 건조", winterWater: "흙 촉촉", temperature: "13 ~ 16", light: ""), journals: [Journal.journal0, Journal.journal1, Journal.journal0, Journal.journal1, Journal.journal0], diaryStyle: DiaryStyle(coverNumber: 0, paintingNumber: 0))
    static let tree = Plant(nickname: "고무고무", info: PlantInfo(contentNo: 13333, plantName: "고무나무", humidity: "70%", fertiliser: "비료 필요", springWater: "자주", summerWater: "흙 촉촉", autumnWater: "흙 건조", winterWater: "흙 촉촉", temperature: "13 ~ 16", light: ""), journals: [], diaryStyle: DiaryStyle(coverNumber: 2, paintingNumber: 4))
    static let grass = Plant(nickname: "풀풀이", info: PlantInfo(contentNo: 18595, plantName: "들풀", humidity: "70%", fertiliser: "비료 필요", springWater: "자주", summerWater: "흙 촉촉", autumnWater: "흙 건조", winterWater: "흙 촉촉", temperature: "13 ~ 16", light: ""), journals: [], diaryStyle: DiaryStyle(coverNumber: 5, paintingNumber: 2))
}

class Journal {
    init() {
        
    }
    
    init(date: Date, weather: Int, isWatering: Bool, content: String, image: Image?) {
        self.date = date
        self.weather = weather
        self.isWatering = isWatering
        self.content = content
        self.image = image
    }
    
    var date = Date.now
    var weather = 0
    var isWatering = false
    var isFertilised = false
    var isSun = false
    var isWind = false
    var content = ""
    var image: Image?
}

extension Journal {
    static let journal0 = Journal(date: Date.now, weather: 0, isWatering: true, content: "오늘은 물을 줬다. 건강하고 씩씩하게 자라 주었으면 하는 마음을 담아서.", image: nil)
    static let journal1 = Journal(date: Date.now, weather: 0, isWatering: false, content: "오늘은 물을 주지 않았다. 물을 주지 않아도 알아서 쑥쑥 자라는 게 기특하다.", image: nil)
}

class DiaryStyle {
    init(coverNumber: Int, paintingNumber: Int) {
        self.cover = coverNumber
        self.painting = paintingNumber
    }
    var cover = 0
    var painting = 0
}
