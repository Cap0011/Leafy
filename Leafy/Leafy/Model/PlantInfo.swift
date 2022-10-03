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
    init(contentNo: Int?, nameKr: String?, nameEng: String?, nameStudy: String?) {
        self.cntntsNo = contentNo
        self.plntbneNm = nameKr
        self.plntzrNm = nameEng
        self.distbNm = nameStudy
    }
    var cntntsNo: Int?
    var plntbneNm: String?
    var plntzrNm: String?
    var distbNm: String?
}
