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
                                .foregroundColor(Color("PhotoPlaceholder"))
                            
                            Image(uiImage: selectedImage)
                                .resizable()
                                .cornerRadius(8)
                            
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("Black"))
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
                                DatePicker("Label", selection: $date, in: ...Date.now, displayedComponents: .date)
                                    .labelsHidden()
                                    .opacity(0.1)
                                    .scaleEffect(x: 3.5)

                                ZStack {
                                    RoundedRectangle(cornerRadius: 23)
                                        .foregroundColor(Color("SearchbarBackground"))
                                        .frame(height: 46)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color("Black"))
                                            .font(.system(size: 16, weight: .semibold))
                                            .padding(.trailing, 16)
                                    }
                                    Text(Utils.formatter.string(from: date))
                                        .font(.custom(FontManager.hand, size: 20))
                                }
                                .userInteractionDisabled()
                            }
                        }
                        
                        HStack {
                            ElementCapsule(isSelected: $isWatering, image: Image(systemName: "drop.fill"), elementName: "물", color: Color("Water"))
                            Spacer()
                            ElementCapsule(isSelected: $isFertilised, image: Image("Fertiliser-selected"), elementName: "비료", color: Color("Fertiliser"))
                            Spacer()
                            ElementCapsule(isSelected: $isSun, image: Image(systemName: "sun.max.fill"), elementName: "햇빛", color: Color("Sun"))
                            Spacer()
                            ElementCapsule(isSelected: $isWind, image: Image(systemName: "wind"), elementName: "통풍", color: Color("Wind"))
                        }
                        
                        // Text editor
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 40) {
                                MyUnderline()
                                MyUnderline()
                                MyUnderline()
                                MyUnderline()
                            }
                            .padding(.top, 40)
                            if contents.isEmpty {
                                Text("일지를 작성해 주세요")
                                    .foregroundColor(Color("GreyText"))
                                    .padding(.leading, 8)
                                    .padding(.top, 5)
                            }
                            if #available(iOS 16.0, *) {
                                TextEditor(text: $contents).id(0)
                                    .focused($inFocus, equals: 0)
                                    .scrollContentBackground(.hidden)
                            } else {
                                TextEditor(text: $contents).id(0)
                                    .focused($inFocus, equals: 0)
                            }
                        }
                        .foregroundColor(Color("Black"))
                        .font(.custom(FontManager.hand, size: 20))
                        .lineSpacing(17)
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
                        dismissKeyboard()
                    }
                }))
            }
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
                    // TODO: Save journal data
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

struct MyUnderline: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color("PhotoPlaceholder"))
            .frame(height: 1)
    }
}

struct ElementCapsule: View {
    @Binding var isSelected: Bool
    let image: Image
    let elementName: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .foregroundColor(isSelected ? Color("Green") : Color("SearchbarBackground"))
            VStack(spacing: 20) {
                image
                    .foregroundColor(color)
                Text(elementName)
                    .font(.custom(FontManager.Pretendard.semiBold, size: 15))
                    .foregroundColor(isSelected ? .white : Color("Black"))
            }
        }
        .frame(width: 72, height: 100)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
