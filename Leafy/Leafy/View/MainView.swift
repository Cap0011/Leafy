//
//  MainView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Diary.entity(),
        sortDescriptors: []
    ) var diaries: FetchedResults<Diary>
    
    @State var selectedDiary: FetchedResults<Diary>.Element?
    
    @State var isShowingActionSheet = false
    @State var isShowingEditToast = false
    @State var isShowingDeleteToast = false
    @State var isShowingAddToast = false
    
    @State var isDeleted = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Background").ignoresSafeArea()
                VStack(spacing: 40) {
                    DiaryCoversView(currentDiary: $selectedDiary, isDelete: $isDeleted)
                    HStack(spacing: 20) {
                        if diaries.count > 0 {
                            if let selectedDiary {
                                NavigationLink(destination: EditDiaryView(diary: selectedDiary, isShowingToast: $isShowingEditToast)) {
                                    Image("edit")
                                }
                            Image("trash")
                                .confirmationDialog("", isPresented: $isShowingActionSheet) {
                                    Button("다이어리 삭제", role: .destructive) {
                                        deleteDiary(diary: selectedDiary)
                                        isShowingDeleteToast.toggle()
                                        isDeleted.toggle()
                                    }
                                    Button("취소", role: .cancel) {}
                                }
                                .onTapGesture {
                                    isShowingActionSheet.toggle()
                                }
                            }
                        }
                        NavigationLink(destination: AddDiaryView(isShowingToast: $isShowingAddToast)) {
                            Image("plus")
                        }
                        .buttonStyle(FlatLinkStyle())
                    }
                    .font(.system(size: 44))
                }
                .padding(.top, 60)
            }
            .preferredColorScheme(.light)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DiaryListView()) {
                        Label("List", systemImage: "books.vertical")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .toast(message: "해당 다이어리가 삭제되었습니다.", isShowing: $isShowingDeleteToast, duration: Toast.short)
        .toast(message: "새로운 다이어리가 추가되었습니다.", isShowing: $isShowingAddToast, duration: Toast.short)
        .toast(message: "해당 다이어리가 수정되었습니다.", isShowing: $isShowingEditToast, duration: Toast.short)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

    func deleteDiary(diary: Diary) {
        self.context.delete(diary)
        
        saveContext()
    }
}

struct DiaryCoversView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Diary.entity(),
        sortDescriptors: []
    ) var diaries: FetchedResults<Diary>
    
    @Binding var currentDiary: FetchedResults<Diary>.Element?

    @State private var offset: CGFloat = 0
    @State private var currentItem = 0
    
    @Binding var isDelete: Bool
    
    private let spacing: CGFloat = 30
    
    var body: some View {
        if diaries.count == 0 {
            VStack(spacing: 20) {
                Image("Demo")
                Text("📚 다이어리를 추가해보세요")
                    .foregroundColor(Color("Black"))
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
            }
            .padding(.top, 90)
        } else {
            GeometryReader { proxy in
                HStack(spacing: self.spacing) {
                    ForEach(Array(diaries.enumerated()), id: \.offset) { idx, diary in
                        DiaryCoverView(diary: diary)
                            .frame(width: 250)
                            .opacity(currentItem == idx ? 1.0 : 0.8)
                            .scaleEffect(currentItem == idx ? 1.0 : 0.9)
                    }
                }
                .onAppear {
                    if diaries.count > 0 {
                        currentDiary = diaries[currentItem]
                    }
                }
                .onChange(of: currentItem) { idx in
                    currentDiary = diaries[currentItem]
                }
                .onChange(of: isDelete) { _ in
                    if diaries.count > 0 {
                        if currentItem != 0 && diaries.count == currentItem {
                            moveToLeft()
                            currentItem -= 1
                        }
                    } else {
                        currentDiary = nil
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
                                        moveToLeft()
                                        currentItem -= 1
                                    }
                                } else {
                                    // Swipe to right
                                    if currentItem != diaries.count - 1 {
                                        moveToRight()
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
    
    func moveToLeft() {
        offset += (250 + self.spacing)
    }
    
    func moveToRight() {
        offset -= (250 + self.spacing)
    }
}

struct DiaryCoverView: View {
    @ObservedObject var diary: Diary

    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                Text(diary.title ?? "다이어리 제목")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                    .padding(.bottom, 2)
                Text(diary.plantName ?? "식물 종류")
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
                    .foregroundColor(Color("GreyText"))
            }
            VStack(spacing: 20) {
                NavigationLink(destination: DiaryDetailView(diary: diary)) {
                    ZStack {
                        Image("Cover\(diary.coverNo)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250)
                        Image("Painting\(diary.paintingNo)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                            .offset(x: 14)
                    }
                }
                .buttonStyle(FlatLinkStyle())
                Text("\(diary.notes?.count ?? 0) 페이지")
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
