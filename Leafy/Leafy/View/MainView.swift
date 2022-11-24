//
//  MainView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var context
        
    @State var isShowingActionSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Background").ignoresSafeArea()
                VStack(spacing: 40) {
                    DiaryCoversView()
                    HStack(spacing: 20) {
                        Image(systemName: "pencil.circle.fill")
                            .onTapGesture {
                                // TODO: Edit
                                print("Edit button tapped!")
                            }
                        Image(systemName: "trash.circle.fill")
                            .confirmationDialog("", isPresented: $isShowingActionSheet) {
                                Button("다이어리 삭제", role: .destructive) {
                                    // TODO: Delete the diary
                                    print("Delete selected!")
                                }
                                Button("취소", role: .cancel) {}
                            }
                            .onTapGesture {
                                isShowingActionSheet.toggle()
                            }
                        NavigationLink(destination: AddDiaryView()) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .buttonStyle(FlatLinkStyle())
                    }
                    .font(.system(size: 44))
                }
                .padding(.top, 60)
            }
            .preferredColorScheme(.light)
            .navigationTitle("")
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
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

struct DiaryCoversView: View {
    @FetchRequest(
        entity: Diary.entity(),
        sortDescriptors: []
    ) var diaries: FetchedResults<Diary>

    @State private var offset: CGFloat = 0
    @State private var currentItem = 0
    
    private let spacing: CGFloat = 30
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: self.spacing) {
                ForEach(Array(diaries.enumerated()), id: \.offset) { idx, diary in
                    DiaryCoverView(diary: diary)
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
                                if currentItem != diaries.count - 1 {
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
    var diary: Diary
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                Text(diary.title ?? "다이어리 제목")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                    .padding(.bottom, 2)
                Text(diary.plantName ?? "식물 종류")
                    .font(.custom(FontManager.Pretendard.medium, size: 15))
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
