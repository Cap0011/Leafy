//
//  MyDatePicker.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/02.
//

import SwiftUI

struct MyDatePicker: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker("", selection: $date, displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle()).labelsHidden()
    }
}
