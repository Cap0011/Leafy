//
//  MainView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Background").ignoresSafeArea()
                
                VStack {
                    DiariesView(plants: [Plant.flower, Plant.grass, Plant.tree])
                        .padding(.bottom, 30)
                    HStack(spacing: 30) {
                        Image(systemName: "trash.circle.fill")
                            .onTapGesture {
                                // TODO: Remove
                            }
                        Image(systemName: "plus.circle.fill")
                            .onTapGesture {
                                // TODO: Add
                            }
                    }
                    .font(.system(size: 44))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Calendar
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Search
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct DiariesView: View {
    var plants: [Plant]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(plants) { plant in
                    DiaryView(plant: plant)
                }
            }
            .padding(.horizontal, 70)
        }
    }
}

struct DiaryView: View {
    var plant: Plant
    
    var body: some View {
        VStack {
            Text(plant.nickname)
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 2)
            Text(plant.info?.distbNm ?? "식물 종류")
                .font(.system(size: 14, weight: .medium))
            NavigationLink(destination: Text("Diary Detail")) {
                Image("Cover")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 360)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
            }
            Text("\(plant.journals.count) 페이지")
                .font(.system(size: 14, weight: .medium))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
