//
//  DiaryDetailView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct DiaryDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let plants = [Plant.flower, Plant.grass, Plant.tree]
    var plant: Plant
    
    @State var isShowingActionSheet = false
    
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            VStack {
                DiaryNoteView(plant: self.plant, isShowingSheet: $isShowingSheet)
                    .padding(.bottom, 40)
                HStack(spacing: 20) {
                    Image(systemName: "pencil.circle.fill")
                        .onTapGesture {
                            // TODO: Edit
                            print("Edit button tapped!")
                        }
                    Image(systemName: "trash.circle.fill")
                        .onTapGesture {
                            isShowingActionSheet.toggle()
                        }
                        .confirmationDialog("", isPresented: $isShowingActionSheet) {
                            Button("페이지 삭제", role: .destructive) {
                                // TODO: Delete
                                print("Delete selected!")
                            }
                            Button("취소", role: .cancel) {}
                        }
                    NavigationLink(destination: AddNoteView()) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(FlatLinkStyle())
                }
                .font(.system(size: 44))
            }
            .padding(.top, 50)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: DiaryListView(plants: plants)) {
                    Label("List", systemImage: "books.vertical")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationTitle("")
        .sheet(isPresented: $isShowingSheet) {
            if #available(iOS 16.0, *) {
                PlantingTipView()
                    .presentationDetents([.fraction(0.75)])
            } else {
                PlantingTipView()
            }
        }
    }
}

struct DiaryNoteView: View {
    let plant: Plant
    
    @Binding var isShowingSheet: Bool
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "y.M.d"
        return formatter
    }
    
    @State var currentPage = 0
    
    var body: some View {
        VStack {
            Text(plant.nickname)
                .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                .padding(.bottom, 24)
            
            Text(plant.info?.distbNm != nil ? "\(plant.info!.distbNm!) 관리 TIP" : "")
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .font(.custom(FontManager.Pretendard.medium, size: 13))
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color("Black")).frame(height: 32))
                .onTapGesture {
                    isShowingSheet.toggle()
                }
            
            ZStack {
                HStack {
                    Image("Note")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .padding(.top, 24)

                    Spacer()
                }
                if currentPage > 1 {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .semibold))
                        .offset(x: -(UIScreen.main.bounds.width / 2 - 24))
                        .onTapGesture {
                            currentPage -= 1
                        }
                }
                if currentPage != plant.journals.count {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 18, weight: .semibold))
                        .offset(x: (UIScreen.main.bounds.width / 2 - 24))
                        .onTapGesture {
                            currentPage += 1
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    if plant.journals.count > 0 && currentPage > 0 {
                        let currentJournal = plant.journals[currentPage - 1]
                        HStack(spacing: 20) {
                            Text(formatter.string(from: currentJournal.date))
                                .font(.custom(FontManager.hand, size: 18))
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(currentJournal.isWatering ? Color("Water") : Color("Unselected"))
                                if currentJournal.isFertilised {
                                    Image("Fertiliser-selected")
                                } else {
                                    Image("Fertiliser-unselected")
                                }
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(currentJournal.isSun ? Color("Sun") : Color("Unselected"))
                                Image(systemName: "wind")
                                    .foregroundColor(currentJournal.isWind ? Color("Wind") : Color("Unselected"))
                            }
                            .offset(y: 3)
                        }
                        
                        if currentJournal.image != nil {
                            currentJournal.image!
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                        } else {
                            Image("PlaceHolder")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                        }
                        ZStack {
                            VStack(spacing: 30) {
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(Color("Unselected"))
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(Color("Unselected"))
                            }
                            .padding(.top, 32)
                            Text(currentJournal.content)
                                .frame(width: 200, height: 50)
                                .font(.custom(FontManager.hand, size: 18))
                                .lineSpacing(8)
                        }
                    }
                }
                .padding(.top)
            }
            .font(.system(size: 18, weight: .semibold))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width < 0 {
                        // Show next page
                        if currentPage != plant.journals.count {
                            currentPage += 1
                        }
                    }
                    
                    if value.translation.width > 0 {
                        // Show previous page
                        if currentPage > 1 {
                            currentPage -= 1
                        }
                    }
                }))
            
            Text("\(currentPage)/\(plant.journals.count) 페이지")
                .font(.custom(FontManager.Pretendard.medium, size: 15))
                .padding(.top, 20)
        }
        .foregroundColor(Color("Black"))
        .onAppear {
            if plant.journals.count > 0 { currentPage = 1 }
        }
    }
}

struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryDetailView(plant: Plant.flower)
    }
}
