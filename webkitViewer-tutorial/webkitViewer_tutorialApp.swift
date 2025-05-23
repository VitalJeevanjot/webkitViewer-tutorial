//
//  webkitViewer_tutorialApp.swift
//  webkitViewer-tutorial
//
//  Created by Jeevanjot Singh on 14/05/25.
//

import SwiftUI
import SwiftData

@main
struct webkitViewer_tutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [FavouritesList.self], inMemory: true)
        }
    }
}
