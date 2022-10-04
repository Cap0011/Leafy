//
//  AddDiaryView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/03.
//

import SwiftUI

struct AddDiaryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var searchText = ""
    
    @State private var nickname = ""
    
    @State private var paintingNumber = 0
    @State private var styleNumber = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Searchbar(text: $searchText)
                        .padding(.horizontal, 24)
                    NicknameTextField(nickname: $nickname)
                    DiaryCoverImage(style: styleNumber, painting: paintingNumber)
                        .padding(.bottom, 24)
                    DiaryCustomScrollView(number: $paintingNumber, title: "커버 이미지", imageName: "Painting", count: 9, spacing: 16)
                    DiaryCustomScrollView(number: $styleNumber, title: "커버 색상", imageName: "Cover", count: 8, spacing: 24)
                }
                .padding(.top, 24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Cancel and return to previous view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Cancel", systemImage: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Black"))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // TODO: Save Diary data
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Green"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Searchbar: View {
    @Binding var text: String
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 23)
                .foregroundColor(Color("SearchbarBackground"))
                .frame(height: 46)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text("식물 종류를 입력해주세요")
                            .font(.custom(FontManager.Pretendard.regular, size: 15))
                    }
                    TextField("", text: $text)
                        .focused($isFocused)
                        .foregroundColor(Color("Black"))
                        .font(.custom(FontManager.Pretendard.regular, size: 18))
                }
                if isFocused {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 12)
                        .onTapGesture {
                            text = ""
                            // TODO: Should miss keyboard?
                            UIApplication.shared.dismissKeyboard()
                        }
                }
            }
            .foregroundColor(Color("GreyText"))
            .padding(.leading, 16)
        }
    }
}

struct NicknameTextField: View {
    @Binding var nickname: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            if nickname.isEmpty && !isFocused {
                HStack(spacing: 4) {
                    Text("식물 이름")
                    Image(systemName: "pencil")
                }
                .foregroundColor(Color("GreyText"))
                .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                .onTapGesture {
                    isFocused = true
                }
            }
            // TODO: Make TextField fit to size
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
