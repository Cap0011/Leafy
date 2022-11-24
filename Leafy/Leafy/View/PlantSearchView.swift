//
//  PlantSearchView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/16.
//

import SwiftUI

struct PlantSearchView: View {
    @State var query = ""
    @ObservedObject var plantListStore = PlantListDataStore.shared
    @State var isLoading = false
    
    @Binding var plantName: String
    @Binding var contentsNumber: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background").ignoresSafeArea()
            VStack {
                Searchbar(text: $query, isLoading: $isLoading)
                if isLoading {
                    HStack {
                        Spacer()
                        ActivityIndicatorView()
                            .padding(.vertical, 14)
                        Spacer()
                    }
                    .padding(.top, 8)
                } else {
                    queryListScrollView(plantList: plantListStore.plantItems, plantName: $plantName, contentsNumber: $contentsNumber)
                        .padding(.top, 8)
                }
            }
            .padding(24)
        }
    }
}

struct Searchbar: View {
    @Binding var text: String
    @Binding var isLoading: Bool
    
    @FocusState var isFocused: Bool
    
    @State var query = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 23)
                .foregroundColor(Color("SearchbarBackground"))
                .frame(height: 46)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text("식물 종 또는 이름")
                            .font(.custom(FontManager.Pretendard.regular, size: 15))
                    }
                    TextField("", text: $text)
                        .focused($isFocused)
                        .font(.custom(FontManager.Pretendard.regular, size: 18))
                        .foregroundColor(Color("Black"))
                        .onSubmit {
                            Task {
                                do {
                                    isLoading = true
                                    try await PlantListDataStore.shared.searchPlantList(query: text)
                                    query = text
                                    isLoading = false
                                } catch {
                                    print(error)
                                }
                            }
                        }
                }
                if isFocused {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 12)
                        .onTapGesture {
                            text = ""
                        }
                }
            }
            .foregroundColor(Color("GreyText"))
            .padding(.leading, 16)
        }
        .onChange(of: text) { text in
            if text != query {
                PlantListDataStore.shared.plantItems = [PlantInfo]()
            }
        }
    }
}

struct queryListScrollView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let plantList: [PlantInfo]
    
    @Binding var plantName: String
    @Binding var contentsNumber: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(plantList, id: \.self.cntntsNo) { plant in
                queryRow(text: plant.plantName ?? "")
                    .onTapGesture {
                        plantName = plant.plantName ?? ""
                        contentsNumber = plant.cntntsNo ?? 0
                        PlantListDataStore.shared.plantItems = [PlantInfo]()
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}

struct queryRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom(FontManager.Pretendard.regular, size: 18))
                .foregroundColor(Color("Black"))
                .padding(.vertical, 8)
            Spacer()
        }
        Divider()
    }
}

struct PlantSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlantSearchView(plantName: .constant("몬스테라"), contentsNumber: .constant(0))
    }
}
