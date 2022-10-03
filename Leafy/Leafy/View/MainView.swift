//
//  MainView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct MainView: View {
    @State var plants = [Plant.flower, Plant.grass, Plant.tree]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Background").ignoresSafeArea()
                VStack(spacing: 40) {
                    DiaryCoversView(plants: plants)
                    HStack(spacing: 20) {
                        Image(systemName: "pencil.circle.fill")
                            .onTapGesture {
                                // TODO: Edit
                                print("Edit button tapped!")
                            }
                        Image(systemName: "trash.circle.fill")
                            .onTapGesture {
                                // TODO: Delete
                                print("Delete button tapped!")
                            }
                        NavigationLink(destination: AddDiaryView()) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .font(.system(size: 44))
                }
                .padding(.top, 60)
            }
            .preferredColorScheme(.light)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DiaryListView(plants: plants)) {
                        Label("List", systemImage: "books.vertical")
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
        .frame(height: 500)
        .animation(.easeInOut, value: offset == 0)
    }
}

struct DiaryCoverView: View {
    var plant: Plant
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                Text(plant.nickname)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 2)
                Text(plant.info?.distbNm ?? "식물 종류")
                    .font(.system(size: 15, weight: .medium))
            }
            VStack(spacing: 20) {
                NavigationLink(destination: DiaryDetailView(plant: self.plant)) {
                    Image("Cover0")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                }
                .buttonStyle(FlatLinkStyle())
                Text("\(plant.journals.count) 페이지")
                    .font(.system(size: 14, weight: .medium))
            }
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
