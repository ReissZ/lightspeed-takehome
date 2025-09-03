//
//  LightspeedTakeHomeApp.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import SwiftUI

@main
struct LightspeedTakeHomeApp: App {
    let persistence = PersistenceService.shared

    var body: some Scene {
        WindowGroup {
            PicsumPhotoListView(context: persistence.container.viewContext)
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
