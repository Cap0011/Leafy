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
            LaunchScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(Color("Black"))
        }
    }
}
