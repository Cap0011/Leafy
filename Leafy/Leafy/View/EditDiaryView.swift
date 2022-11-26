//
//  EditDiaryView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/11/25.
//

import SwiftUI

struct EditDiaryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var context
    
    @State var diary: FetchedResults<Diary>.Element
    
    @State private var plantName = ""
    @State private var contentsNumber = -1
    
    @State private var nickname = ""
    
    @State private var paintingNumber = 0
    @State private var styleNumber = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    SearchbarEntryView(plantName: $plantName, contentsNo: $contentsNumber)
                        .padding(.horizontal, 24)
                    titleLable
                    NicknameTextField(nickname: $nickname)
                        .padding(.top, -14)
                    DiaryCoverImage(style: styleNumber, painting: paintingNumber)
                        .padding(.bottom, 24)
                    DiaryCustomScrollView(number: $paintingNumber, title: "커버 이미지", imageName: "Painting", count: 9, spacing: 16)
                    DiaryCustomScrollView(number: $styleNumber, title: "커버 색상", imageName: "Cover", count: 8, spacing: 24)
                }
                .padding(.top, 24)
            }
        }
        .task {
            plantName = diary.plantName ?? ""
            contentsNumber = Int(diary.plantNo)
            nickname = diary.title ?? ""
            styleNumber = Int(diary.coverNo)
            paintingNumber = Int(diary.paintingNo)
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Cancel", systemImage: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Black"))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("다이어리 수정")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                    .foregroundColor(Color("Black"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editDiary(plantName: plantName, plantNo: contentsNumber, title: nickname, coverNo: styleNumber, paintingNo: paintingNumber)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Green"))
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
    
    var titleLable: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 58, height: 24)
                .foregroundColor(Color("Black"))
            Text("TITLE")
                .font(.custom(FontManager.Pretendard.medium, size: 13))
                .foregroundColor(.white)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func editDiary(plantName: String, plantNo: Int, title: String, coverNo: Int, paintingNo: Int) {
        diary.plantName = plantName
        diary.plantNo = Int64(plantNo)
        diary.title = title
        diary.coverNo = Int64(coverNo)
        diary.paintingNo = Int64(paintingNo)
        
        saveContext()
    }
}
