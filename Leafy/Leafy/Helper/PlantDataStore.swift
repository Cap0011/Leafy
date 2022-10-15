//
//  PlantDataStore.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import Foundation

enum XMLKeys: String {
    case id = "cntntsNo"
    case plantName = "distbNm"
    case humidity = "hdCodeNm"
    case fertiliser = "frtlzrInfo"
    case springWater = "watercycleSprngCode"
    case summerWater = "watercycleSummerCode"
    case autumnWater = "watercycleAutumnCode"
    case winterWater = "watercycleWinterCode"
    case temperature = "grwhTpCodeNm"
    case searchPlantName = "cntntsSj"
}

class PlantDataStore: NSObject, XMLParserDelegate {
    static let shared = PlantDataStore()
    
    let baseDetailURL = "http://api.nongsaro.go.kr/service/garden/gardenDtl"
    
    var currentElement = ""
    var plantItem = PlantInfo()
    
    var contentNo = 0
    var plantName = ""
    var humidity = ""
    var fertiliser = ""
    var springWater = ""
    var summerWater = ""
    var autumnWater = ""
    var winterWater = ""
    var temperature = ""
    
    func loadPlantData(contentsNumber: Int) async throws {
        guard let url = URL(string: "\(baseDetailURL)?apiKey=\(Secret.apiKey)&cntntsNo=\(contentsNumber)") else {
            print("Invalid URL")
            return
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let xmlParser = XMLParser(data: data)
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 태그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            plantItem = PlantInfo()
        }
    }
    
    // XML 파서가 종료 태그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            plantItem.plantName = plantName
            plantItem.cntntsNo = contentNo
            plantItem.humidity = humidity
            plantItem.fertiliser = fertiliser
            plantItem.springWater = springWater
            plantItem.summerWater = summerWater
            plantItem.autumnWater = autumnWater
            plantItem.winterWater = winterWater
            plantItem.temperature = temperature
        }
    }
    
    // 현재 태그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == XMLKeys.id.rawValue) {
            contentNo = Int(string) ?? 0
        }
        else if (currentElement == XMLKeys.plantName.rawValue) {
            plantName = string
        } else if (currentElement == XMLKeys.humidity.rawValue) {
            humidity = string
        } else if (currentElement == XMLKeys.fertiliser.rawValue) {
            fertiliser = string
        } else if (currentElement == XMLKeys.springWater.rawValue) {
            springWater = string
        } else if (currentElement == XMLKeys.summerWater.rawValue) {
            summerWater = string
        } else if (currentElement == XMLKeys.autumnWater.rawValue) {
            autumnWater = string
        } else if (currentElement == XMLKeys.winterWater.rawValue) {
            winterWater = string
        } else if (currentElement == XMLKeys.temperature.rawValue) {
            temperature = string
        }
    }
}
