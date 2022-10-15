//
//  PlantInfo.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import Foundation

class PlantInfo {
    init() {
    }
    
    init(contentNo: Int?, plantName: String?, humidity: String?, fertiliser: String?, springWater: String?, summerWater: String?, autumnWater: String?, winterWater: String?, temperature: String?) {
        self.cntntsNo = contentNo
        self.plantName = plantName
        self.humidity = humidity
        self.fertiliser = fertiliser
        self.springWater = springWater
        self.summerWater = summerWater
        self.autumnWater = autumnWater
        self.winterWater = winterWater
        self.temperature = temperature
    }
    
    var cntntsNo: Int?
    var plantName: String?
    var humidity: String?
    var fertiliser: String?
    var springWater: String?
    var summerWater: String?
    var autumnWater: String?
    var winterWater: String?
    var temperature: String?
}
