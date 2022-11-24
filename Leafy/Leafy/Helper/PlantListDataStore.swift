//
//  PlantListDataStore.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/16.
//

import Foundation

@MainActor
class PlantListDataStore: NSObject, XMLParserDelegate, ObservableObject {
    static let shared = PlantListDataStore()
    
    let baseListURL = "http://api.nongsaro.go.kr/service/garden/gardenList"
    
    var currentElement = ""
    @Published var plantItems = [PlantInfo]()
    var plantItem = PlantInfo()
    
    var contentNo = 0
    var plantName = ""

    func searchPlantList(query: String) async throws {
        plantItems = [PlantInfo]()
        
        let urlString = "\(baseListURL)?apiKey=\(Secret.apiKey)&sType=sCntntsSj&wordType=cntntsSj&sText=\(query)"
        let convertedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        guard let url = URL(string: convertedURL) else {
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
            
            plantItems.append(plantItem)
        }
    }
    
    // 현재 태그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == XMLKeys.id.rawValue) {
            contentNo = Int(string) ?? 0
        }
        else if (currentElement == XMLKeys.searchPlantName.rawValue) {
            plantName = string
        }
    }
}
