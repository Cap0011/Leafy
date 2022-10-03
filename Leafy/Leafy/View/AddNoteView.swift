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
    
    @State private var isWatering = false
    @State private var isFertilised = false
    @State private var isSun = false
    @State private var isWind = false
    
    @State private var contents = ""
    @State private var date = Date()
    
    @FocusState var inFocus: Int?

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.gray)
                                .opacity(0.1)
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                            
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 44))
                        }
                        .frame(height: UIScreen.main.bounds.width - 48)
                        .padding(.top, 24)
                        .onTapGesture {
                            isShowingActionSheet.toggle()
                        }
                        .confirmationDialog("", isPresented: $isShowingActionSheet) {
                            Button("사진 찍기", role: .none) {
                                isCameraChoosed.toggle()
                            }
                            Button("사진 선택", role: .none) {
                                isGalleryChoosed.toggle()
                            }
                            Button("취소", role: .cancel) {}
                        }
                        
                        ZStack(alignment: .trailing) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 23)
                                    .foregroundColor(.gray)
                                    .opacity(0.1)
                                    .frame(height: 46)
                                
                                DatePicker("", selection: $date, in: ...Date.now, displayedComponents: .date).labelsHidden()
                                    .opacity(0.1)
                            }

                            Image(systemName: "chevron.down")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.trailing, 12)
                        }
                        
                        HStack {
                            ElementCapsule(isSelected: $isWatering, imageName: "drop.fill", elementName: "물", color: .cyan.opacity(0.6))
                            ElementCapsule(isSelected: $isFertilised, imageName: "circle.hexagongrid.fill", elementName: "비료", color: .brown)
                            ElementCapsule(isSelected: $isSun, imageName: "sun.max.fill", elementName: "햇빛", color: .yellow)
                            ElementCapsule(isSelected: $isWind, imageName: "wind", elementName: "통풍", color: .blue)
                        }
                        
                        // Text editor
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $contents).id(0)
                                .focused($inFocus, equals: 0)
                            if contents.isEmpty {
                                Text("일지를 작성해 주세요")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal, 24)
                }
                .onChange(of: inFocus) { id in
                    withAnimation {
                        proxy.scrollTo(id)
                    }
                }
                .simultaneousGesture(DragGesture().onChanged({ gesture in
                    withAnimation{
                        UIApplication.shared.dismissKeyboard()
                    }
                }))
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
                    // TODO: Save data
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("Green"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isCameraChoosed) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .sheet(isPresented: $isGalleryChoosed) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
    }
}

struct ElementCapsule: View {
    @Binding var isSelected: Bool
    let imageName: String
    let elementName: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .foregroundColor(isSelected ? .green : .gray.opacity(0.1))
            VStack(spacing: 20) {
                Image(systemName: imageName)
                    .foregroundColor(color)
                Text(elementName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .black)
            }
        }
        .frame(height: 100)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
