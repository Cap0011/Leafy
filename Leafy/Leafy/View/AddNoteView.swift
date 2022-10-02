//
//  AddNoteView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isShowingActionSheet = false
    @State private var isCameraChoosed = false
    @State private var isGalleryChoosed = false
    
    @State private var selectedImage = UIImage()

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.1)
                        .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    isShowingActionSheet.toggle()
                }
                .confirmationDialog("", isPresented: $isShowingActionSheet) {
                    Button("사진 찍기", role: .none) {
                        isCameraChoosed.toggle()
                    }
                    Button("앨범에서 선택", role: .none) {
                        isGalleryChoosed.toggle()
                    }
                    Button("취소", role: .cancel) {}
                }
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
                Button {
                    // TODO: Save data
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("완료")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $isCameraChoosed) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .sheet(isPresented: $isGalleryChoosed) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
