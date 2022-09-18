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
    static let flower = Plant(nickname: "백백이", info: PlantInfo(contentNo: 0, nameKr: "동백", nameEng: "flower", nameStudy: "동백"), journals: [])
    static let tree = Plant(nickname: "고무고무", info: PlantInfo(contentNo: 1, nameKr: "고무나무", nameEng: "tree", nameStudy: "고무나무"), journals: [])
    static let grass = Plant(nickname: "풀풀이", info: PlantInfo(contentNo: 2, nameKr: "이름모를", nameEng: "grass", nameStudy: "들풀"), journals: [])
}

class Journal {
    var date = Date()
    var weather = 0
    var isWatering = false
    var content = ""
    var image: Image?
}
