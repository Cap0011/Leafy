//
//  DiaryListView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/02.
//

import SwiftUI

struct DiaryListView: View {
    @State var plants: [Plant]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            VStack {
                ForEach(plants) { plant in
                    DiaryListRow(plant: plant)
                        .padding(.vertical, 20)
                    Divider()
                }
            }
            .padding(.horizontal, 24)
        }
        .tint(.black)
    }
}

struct DiaryListRow: View {
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 20) {
            Image("Cover0")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(plant.nickname)
                    .font(.system(size: 18, weight: .semibold))
                Text(plant.info?.distbNm ?? "")
                    .font(.system(size: 15, weight: .regular))
            }
             
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "pencil")
                    .onTapGesture {
                        // TODO: Edit the diary
                    }
                Image(systemName: "trash")
                    .onTapGesture {
                        // TODO: Delete the diary
                    }
            }
        }
    }
}

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView(plants: [Plant.flower, Plant.grass, Plant.tree])
    }
}
