//
//  AddDiaryView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/03.
//

import SwiftUI

struct AddDiaryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var context
    
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addDiary(plantName: plantName, plantNo: contentsNumber, title: nickname, coverNo: styleNumber, paintingNo: paintingNumber)
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
    
    func addDiary(plantName: String, plantNo: Int, title: String, coverNo: Int, paintingNo: Int) {
        let newDiary = Diary(context: context)
        
        newDiary.plantName = plantName
        newDiary.plantNo = Int64(plantNo)
        newDiary.title = title
        newDiary.coverNo = Int64(coverNo)
        newDiary.paintingNo = Int64(paintingNo)
        
        saveContext()
    }
}

struct SearchbarEntryView: View {
    @Binding var plantName: String
    @Binding var contentsNo: Int
    
    var body: some View {
        NavigationLink(destination: PlantSearchView(plantName: $plantName, contentsNumber: $contentsNo)) {
            ZStack {
                RoundedRectangle(cornerRadius: 23)
                    .foregroundColor(Color("SearchbarBackground"))
                    .frame(height: 46)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("GreyText"))
                    Spacer()
                }
                .padding(.leading, 16)
                if plantName.isEmpty {
                    Text("어떤 식물을 기록하시나요?")
                        .font(.custom(FontManager.Pretendard.regular, size: 15))
                        .foregroundColor(Color("GreyText"))
                } else {
                    Text(plantName)
                        .font(.custom(FontManager.Pretendard.regular, size: 18))
                        .foregroundColor(Color("Black"))
                }
            }
        }
    }
}

struct NicknameTextField: View {
    @Binding var nickname: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            if nickname.isEmpty && !isFocused {
                Text("다이어리")
                    .underline(true)
                    .foregroundColor(Color("GreyText"))
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                    .onTapGesture {
                        isFocused = true
                    }
            }
            TextField("", text: $nickname)
                .fixedSize()
                .focused($isFocused)
                .foregroundColor(Color("Black"))
                .font(.custom(FontManager.Pretendard.semiBold, size: 18))
        }
    }
}

struct DiaryCoverImage: View {
    let style: Int
    let painting: Int
    
    var body: some View {
        ZStack {
            Image("Cover\(style)")
                .resizable()
                .scaledToFit()
                .frame(width: 196)
            Image("Painting\(painting)")
                .resizable()
                .scaledToFit()
                .frame(width: 110)
                .offset(x: 7)
        }
    }
}

struct DiaryCustomScrollView: View {
    @Binding var number: Int
    
    let title: String
    let imageName: String
    let count: Int
    let spacing: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom(FontManager.Pretendard.medium, size: 15))
                .padding(.leading, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<count, id: \.self) { idx in
                        Image("\(imageName)\(idx)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64)
                            .onTapGesture {
                                number = idx
                            }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct AddDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiaryView()
    }
}
