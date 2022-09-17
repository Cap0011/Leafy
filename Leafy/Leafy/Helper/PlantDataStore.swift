//
//  PlantDataStore.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import Foundation

enum XMLKeys: String {
    case cntntsNo = "cntntsNo"
    case plntbneNm = "plntbneNm"
    case plntzrNm = "plntzrNm"
    case distbNm = "distbNm"
}

class PlantDataStore: NSObject, XMLParserDelegate {
    static let shared = PlantDataStore()
    let baseDetailURL = "http://api.nongsaro.go.kr/service/garden/gardenDtl"
    let baseListURL = "http://api.nongsaro.go.kr/service/garden/gardenList"
    let contentsNumber = 14663
    
    var currentElement = ""
    var plantItems = [PlantData]()
    var plantItem = PlantData()
    
    var contentNo = 0
    var nameKr = ""
    var nameEng = ""
    var nameStudy = ""
    
    func loadPlantData() {
        guard let url = URL(string: "\(baseDetailURL)?apiKey=\(Secret.apiKey)&cntntsNo=\(contentsNumber)") else {
            print("Invalid URL")
            return
        }
        
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 태그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            plantItem = PlantData()
        }
    }
    
    // XML 파서가 종료 태그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            plantItem.plntbneNm = nameKr
            plantItem.plntzrNm = nameEng
            plantItem.distbNm = nameStudy
            plantItem.cntntsNo = contentNo
            
            plantItems.append(plantItem)
        }
    }
    
    // 현재 태그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == XMLKeys.plntbneNm.rawValue) {
            nameKr = string
        } else if (currentElement == XMLKeys.plntzrNm.rawValue) {
            nameEng = string
        } else if (currentElement == XMLKeys.distbNm.rawValue) {
            nameStudy = string
        } else if (currentElement == XMLKeys.cntntsNo.rawValue) {
            contentNo = Int(string) ?? 0
        }
    }
}
