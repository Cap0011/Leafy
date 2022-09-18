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
                PlantDataStore.shared.loadPlantData()
            }
            .onTapGesture {
                print(PlantDataStore.shared.plantItems.first?.distbNm)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
