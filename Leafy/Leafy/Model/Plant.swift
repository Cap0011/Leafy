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
    
    init(nickname: String, info: PlantInfo?, journals: [Journal]) {
        self.nickname = nickname
        self.info = info
        self.journals = journals
    }
    
    var nickname = ""
    var info: PlantInfo?
    var journals = [Journal]()
}

extension Plant {
    static let flower = Plant(nickname: "백백이", info: PlantInfo(contentNo: 0, nameKr: "동백", nameEng: "flower", nameStudy: "동백"), journals: [Journal.journal0, Journal.journal1, Journal.journal0, Journal.journal1, Journal.journal0])
    static let tree = Plant(nickname: "고무고무", info: PlantInfo(contentNo: 1, nameKr: "고무나무", nameEng: "tree", nameStudy: "고무나무"), journals: [])
    static let grass = Plant(nickname: "풀풀이", info: PlantInfo(contentNo: 2, nameKr: "이름모를", nameEng: "grass", nameStudy: "들풀"), journals: [])
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
    var content = ""
    var image: Image?
}

extension Journal {
    static let journal0 = Journal(date: Date.now, weather: 0, isWatering: true, content: "오늘은 물을 줬다. 매일 똑같은 쳇바퀴를 굴리며 살아가는 나 대신 건강하고 씩씩하게 자라 주었으면 하는 마음을 담아서.", image: nil)
    static let journal1 = Journal(date: Date.now, weather: 0, isWatering: false, content: "오늘은 물을 주지 않았다. 물을 주지 않아도 알아서 쑥쑥 자라는 게 기특하다.", image: nil)
}
