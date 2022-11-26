//
//  DiaryListView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/02.
//

import SwiftUI

struct DiaryListView: View {
    @FetchRequest(
        entity: Diary.entity(),
        sortDescriptors: []
    ) var diaries: FetchedResults<Diary>
    
    @State var isShowingEditToast = false
    @State var isShowingDeleteToast = false
    @State var isShowingAddToast = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(diaries) { diary in
                        NavigationLink(destination: DiaryDetailView(diary: diary)) {
                            DiaryListRow(diary: diary, isShowingEditToast: $isShowingEditToast, isShowingDeleteToast: $isShowingDeleteToast)
                                .padding(.vertical, 20)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(FlatLinkStyle())
                        
                        Divider()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .toast(message: "해당 다이어리가 삭제되었습니다.", isShowing: $isShowingDeleteToast, duration: Toast.short)
        .toast(message: "새로운 다이어리가 추가되었습니다.", isShowing: $isShowingAddToast, duration: Toast.short)
        .toast(message: "해당 다이어리가 수정되었습니다.", isShowing: $isShowingEditToast, duration: Toast.short)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("다이어리 목록")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                    .foregroundColor(Color("Black"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddDiaryView(isShowingToast: $isShowingAddToast)) {
                    Image(systemName: "plus")
                        .foregroundColor(Color("Black"))
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
}

struct DiaryListRow: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var diary: Diary
    
    @State var isShowingActionSheet = false
    @Binding var isShowingEditToast: Bool
    @Binding var isShowingDeleteToast: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Image("Cover\(diary.coverNo)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Image("Painting\(diary.paintingNo)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .offset(x: 3)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(diary.title ?? "다이어리 제목")
                    .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                Text(diary.plantName ?? "식물 종류")
                    .font(.custom(FontManager.Pretendard.regular, size: 15))
                    .foregroundColor(Color("GreyText"))
            }
             
            Spacer()
            
            HStack(spacing: 16) {
                NavigationLink(destination: EditDiaryView(diary: diary, isShowingToast: $isShowingEditToast)) {
                    Image(systemName: "pencil")
                }
                Image(systemName: "trash")
                    .confirmationDialog("", isPresented: $isShowingActionSheet) {
                        Button("다이어리 삭제", role: .destructive) {
                            deleteDiary(diary: diary)
                            isShowingDeleteToast.toggle()
                        }
                        Button("취소", role: .cancel) {}
                    }
                    .onTapGesture {
                        isShowingActionSheet.toggle()
                    }
            }
            .font(.system(size: 18, weight: .semibold))
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

struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryListView()
    }
}
