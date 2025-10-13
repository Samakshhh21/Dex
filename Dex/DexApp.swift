//
//  DexApp.swift
//  Dex
//
//  Created by Samaksh Sangwan on 13/10/25.
//

import SwiftUI
import CoreData

@main
struct DexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
