//
//  DiaryDetailView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct DiaryDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var plant: Plant
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            
            VStack {
                DiaryNoteView(plant: self.plant)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddNoteView()) {
                    Label("Add", systemImage: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DiaryNoteView: View {
    let plant: Plant
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "y.M.d"
        return formatter
    }
    
    @State var currentPage = 0
    
    var body: some View {
        VStack {
            Text(plant.nickname)
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 2)
            Text(plant.info?.distbNm ?? "식물 종류")
                .font(.system(size: 14, weight: .medium))
            ZStack {
                HStack {
                    Image("Note")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .padding(.top, 40)
                        .padding(.bottom, 10)

                    Spacer()
                }
                if currentPage > 1 {
                    Image(systemName: "arrow.backward")
                        .offset(x: -(UIScreen.main.bounds.width / 2 - 20))
                        .onTapGesture {
                            currentPage -= 1
                        }
                }
                if currentPage != plant.journals.count {
                    Image(systemName: "arrow.forward")
                        .offset(x: (UIScreen.main.bounds.width / 2 - 20))
                        .onTapGesture {
                            currentPage += 1
                        }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    if plant.journals.count > 0 && currentPage > 0 {
                        let currentJournal = plant.journals[currentPage - 1]
                        HStack {
                            Text(formatter.string(from: currentJournal.date))
                                .font(.system(size: 16))
                            Image(systemName: "drop.fill")
                                .foregroundColor(.cyan)
                                .opacity(currentJournal.isWatering ? 0.6 : 0.0)
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
                        Text(currentJournal.content)
                            .frame(width: 200, height: 50)
                            .font(.system(size: 14, weight: .medium))
                            .lineSpacing(5)
                    }
                }
                .padding(.top, 40)
            }
            .font(.system(size: 18, weight: .semibold))
            Text("\(currentPage)/\(plant.journals.count) 페이지")
                .font(.system(size: 14, weight: .medium))
        }
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
