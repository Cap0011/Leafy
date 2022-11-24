//
//  LeafyApp.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/09/15.
//

import SwiftUI

@main
struct LeafyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
