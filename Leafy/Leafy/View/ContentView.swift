//
//  ContentView.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .task {
                do {
//                    try await PlantDataStore.shared.loadPlantData(contentsNumber: 14663)
                    try await PlantListDataStore.shared.searchPlantList(query: "몬스테라")
                } catch {
                    print(error)
                }
            }
            .onTapGesture {
//                print(PlantDataStore.shared.plantItem.plantName)
                print(PlantListDataStore.shared.plantItems.first?.plantName)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
