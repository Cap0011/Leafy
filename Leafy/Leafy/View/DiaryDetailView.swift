//
//  DiaryDetailView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/18.
//

import SwiftUI

struct DiaryDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var context
    
    @State var diary: FetchedResults<Diary>.Element
    
    @State var isShowingActionSheet = false
    
    @State private var isShowingSheet = false
    @State private var isShowingNoteSheet = false
    @State private var isNoteChanged = false
    
    @State var currentPage = 0
    
    @State var notes = [Note]()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            VStack {
                DiaryNoteView(diary: diary, notes: notes, isShowingSheet: $isShowingSheet, isShowingNoteSheet: $isShowingNoteSheet, isChanged: $isNoteChanged, currentPage: $currentPage)
                    .padding(.bottom, 40)
                HStack(spacing: 20) {
                    if diary.notes?.count ?? 0 > 0 {
                        Image(systemName: "pencil.circle.fill")
                            .onTapGesture {
                                // TODO: Open EditNoteView
                                print("Edit button tapped!")
                            }
                        Image(systemName: "trash.circle.fill")
                            .onTapGesture {
                                isShowingActionSheet.toggle()
                            }
                            .confirmationDialog("", isPresented: $isShowingActionSheet) {
                                Button("페이지 삭제", role: .destructive) {
                                    deleteNote(note: notes[currentPage - 1])
                                    if currentPage != 1 {
                                        currentPage -= 1
                                    } else if currentPage == 1 && diary.notes?.count == 0 {
                                        currentPage = 0
                                    }
                                    isNoteChanged.toggle()
                                }
                                Button("취소", role: .cancel) {}
                            }
                    }
                    NavigationLink(destination: AddNoteView(diary: diary)) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(FlatLinkStyle())
                }
                .font(.system(size: 44))
            }
            .padding(.top, 50)
        }
        .onChange(of: diary.notes?.count) { _ in
            isNoteChanged.toggle()
            if let diaryNotes = diary.notes {
                notes = diaryNotes.allObjects as! [Note]
                notes.sort { $0.date ?? Date() < $1.date ?? Date() }
            }
            if diary.notes?.count ?? 0 > 0 && currentPage == 0 { currentPage = 1 }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: DiaryListView()) {
                    Label("List", systemImage: "books.vertical")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationTitle("")
        .sheet(isPresented: $isShowingSheet) {
            if #available(iOS 16.0, *) {
                PlantingTipView(contentsNumber: Int(diary.plantNo))
                    .presentationDetents([.fraction(0.75)])
            } else {
                PlantingTipView(contentsNumber: Int(diary.plantNo))
            }
        }
        .sheet(isPresented: $isShowingNoteSheet) {
            if #available(iOS 16.0, *) {
                NoteDetailView(journal: notes[currentPage - 1].journal ?? "")
                    .presentationDetents([.fraction(0.75)])
            } else {
                NoteDetailView(journal: notes[currentPage - 1].journal ?? "")
            }
        }
        .task {
            if let diaryNotes = diary.notes {
                notes = diaryNotes.allObjects as! [Note]
                notes.sort { $0.date ?? Date() < $1.date ?? Date() }
            }
            if diary.notes?.count ?? 0 > 0 && currentPage == 0 { currentPage = 1 }
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

    func deleteNote(note: Note) {
        diary.removeFromNotes(note)
        self.context.delete(note)
        
        saveContext()
    }
}

struct DiaryNoteView: View {
    @ObservedObject var diary: Diary
    @State var notes = [Note]()
    
    @Binding var isShowingSheet: Bool
    @Binding var isShowingNoteSheet: Bool
    @Binding var isChanged: Bool
    
    @Binding var currentPage: Int

    var body: some View {
        VStack {
            Text(diary.title ?? "다이어리 제목")
                .font(.custom(FontManager.Pretendard.semiBold, size: 18))
                .padding(.bottom, 24)

            Text("\(diary.plantName ?? "식물 종류") 관리 TIP")
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .font(.custom(FontManager.Pretendard.medium, size: 13))
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color("Black")).frame(height: 32))
                .onTapGesture {
                    isShowingSheet.toggle()
                }

            ZStack {
                HStack {
                    Image("Note")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .padding(.top, 24)

                    Spacer()
                }
                if currentPage > 1 {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .semibold))
                        .offset(x: -(UIScreen.main.bounds.width / 2 - 24))
                        .onTapGesture {
                            currentPage -= 1
                        }
                }
                if currentPage < notes.count {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 18, weight: .semibold))
                        .offset(x: (UIScreen.main.bounds.width / 2 - 24))
                        .onTapGesture {
                            currentPage += 1
                        }
                }

                VStack(alignment: .leading, spacing: 8) {
                    if notes.count > 0 && currentPage > 0 {
                        let currentNote = notes[currentPage - 1]
                        HStack(spacing: 20) {
                            Text(Utils.formatter.string(from: currentNote.date ?? Date()))
                                .font(.custom(FontManager.hand, size: 18))
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(currentNote.isWatered ? Color("Water") : Color("Unselected"))
                                if currentNote.isFertilised {
                                    Image("Fertiliser-selected")
                                } else {
                                    Image("Fertiliser-unselected")
                                }
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(currentNote.isSun ? Color("Sun") : Color("Unselected"))
                                Image(systemName: "wind")
                                    .foregroundColor(currentNote.isWind ? Color("Wind") : Color("Unselected"))
                            }
                            .offset(y: 3)
                        }

                        if let data = currentNote.image, let uiImage = UIImage(data: data), let image = Image(uiImage: uiImage) {
                            NavigationLink(destination: NoteImageView(image: image)) {
                                image
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .scaledToFit()
                                    .cornerRadius(8)
                                    .rotationEffect(.degrees(90))
                            }
                        } else {
                            Image("PlaceHolder")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                                .cornerRadius(8)
                        }
                        ZStack {
                            VStack(spacing: 30) {
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(Color("Unselected"))
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(Color("Unselected"))
                            }
                            .padding(.top, 32)
                            Text(currentNote.journal ?? "")
                                .frame(width: 200, height: 50, alignment: .topLeading)
                                .font(.custom(FontManager.hand, size: 18))
                                .lineSpacing(8)
                        }
                    }
                }
                .padding(.top)
            }
            .font(.system(size: 18, weight: .semibold))
            .onTapGesture {
                if notes.count > 0 {
                    isShowingNoteSheet = true
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width < 0 {
                        // Show next page
                        if currentPage != diary.notes?.count {
                            currentPage += 1
                        }
                    }

                    if value.translation.width > 0 {
                        // Show previous page
                        if currentPage > 1 {
                            currentPage -= 1
                        }
                    }
                })
            )
            Text("\(currentPage)/\(diary.notes?.count ?? 0) 페이지")
                .font(.custom(FontManager.Pretendard.medium, size: 15))
                .padding(.top, 20)
        }
        .foregroundColor(Color("Black"))
        .onChange(of: isChanged) { _ in
            notes = diary.notes?.allObjects as! [Note]
            notes.sort { $0.date ?? Date() < $1.date ?? Date() }
//            print("onChange: notes.count-\(notes.count), currentPage-\(currentPage)")
//            print(diary.notes)
            if notes.count == 0 { currentPage = 0 }
        }
        .onAppear {
            notes = diary.notes?.allObjects as! [Note]
            notes.sort { $0.date ?? Date() < $1.date ?? Date() }
        }
    }
}
