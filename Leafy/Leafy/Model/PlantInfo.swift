//
//  PlantInfo.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import Foundation

class PlantInfo: ObservableObject, Codable {
    @Published var plantName = ""
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        plantName = try container.decode(String.self, forKey: .plantName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(plantName, forKey: .plantName)
    }
    
    enum CodingKeys: CodingKey {
        case plantName
    }
}
