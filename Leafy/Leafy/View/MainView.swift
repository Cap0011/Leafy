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
                    DiaryCoversView(plants: [Plant.flower, Plant.grass, Plant.tree])
                    HStack(spacing: 20) {
                        Image(systemName: "trash.circle.fill")
                            .onTapGesture {
                                // TODO: Delete
                                print("Delete button tapped!")
                            }
                        Image(systemName: "plus.circle.fill")
                            .onTapGesture {
                                // TODO: Add
                                print("Add button tapped!")
                            }
                    }
                    .font(.system(size: 44))
                    .offset(y: -80)
                }
            }
            .preferredColorScheme(.light)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CalendarView()) {
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

struct DiaryCoversView: View {
    var plants: [Plant]

    @State private var offset: CGFloat = 0
    @State private var currentItem = 0
    
    private let spacing: CGFloat = 30
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: self.spacing) {
                ForEach(0..<plants.count, id: \.self) { idx in
                    DiaryCoverView(plant: plants[idx])
                        .frame(width: 250)
                        .opacity(currentItem == idx ? 1.0 : 0.8)
                        .scaleEffect(currentItem == idx ? 1.0 : 0.9)
                }
            }
            .offset(x: offset)
            .padding(.horizontal, 70)
            .highPriorityGesture(
                DragGesture()
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width > 0 {
                                // Swipe to left
                                if currentItem != 0 {
                                    offset += (250 + self.spacing)
                                    currentItem -= 1
                                }
                            } else {
                                // Swipe to right
                                if currentItem != plants.count - 1 {
                                    offset -= (250 + self.spacing)
                                    currentItem += 1
                                }
                            }
                        }
                    }
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

struct DiaryCoverView: View {
    var plant: Plant
    
    var body: some View {
        VStack {
            Text(plant.nickname)
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 2)
            Text(plant.info?.distbNm ?? "식물 종류")
                .font(.system(size: 14, weight: .medium))
            NavigationLink(destination: DiaryDetailView(plant: self.plant)) {
                Image("Cover")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 360)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
            }
            .buttonStyle(FlatLinkStyle())
            Text("\(plant.journals.count) 페이지")
                .font(.system(size: 14, weight: .medium))
        }
    }
    
    struct FlatLinkStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
