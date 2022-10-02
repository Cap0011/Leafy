//
//  CalendarView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/21.
//

import SwiftUI

struct CalendarView: View {
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "y년 M월"
        return formatter
    }
    
    var body: some View {
        VStack {
            Text(formatter.string(from: Date.now))
            HStack(spacing: 40) {
                ForEach(Weekdays.allCases, id: \.self) { weekday in
                    Text(weekday.rawValue)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
