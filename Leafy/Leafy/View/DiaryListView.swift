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
            .padding(.top, 40)
        }
        .tint(.black)
    }
}

struct DiaryListRow: View {
    let plant: Plant
    
    @State var isShowingActionSheet = false
    
    var body: some View {
        HStack(spacing: 20) {
            Image("Cover0")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(plant.nickname)
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                Text(plant.info?.distbNm ?? "")
                    .font(.custom(FontManager.Pretendard.regular, size: 15))
            }
             
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "pencil")
                    .onTapGesture {
                        // TODO: Edit the diary
                    }
                Image(systemName: "trash")
                    .confirmationDialog("", isPresented: $isShowingActionSheet) {
                        Button("다이어리 삭제", role: .destructive) {
                            // TODO: Delete the diary
                            print("Delete selected!")
                        }
                        Button("취소", role: .cancel) {}
                    }
                    .onTapGesture {
                        isShowingActionSheet.toggle()
                    }
            }
            .font(.system(size: 18, weight: .semibold))
        }
    }
}

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView(plants: [Plant.flower, Plant.grass, Plant.tree])
    }
}
