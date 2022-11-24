//
//  Constant.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/11/24.
//

import Foundation

class Constant {
    static func waterCycleString(code: Int) -> String {
        switch(code) {
        case 53001: return "항상 흙을 축축하게 유지함 (물에 잠김)"
        case 53002: return "흙을 촉촉하게 유지함 (물에 잠기지 않도록 주의)"
        case 53003: return "토양 표면이 말랐을 때 충분히 관수함"
        case 53004: return "화분 흙이 말랐을 때 충분히 관수함"
        default: return ""
        }
    }
}
