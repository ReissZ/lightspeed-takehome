//
//  PersistenceService.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import CoreData

struct PersistenceService {
    static let shared = PersistenceService()

    @MainActor
    static let preview: PersistenceService = {
        let result = PersistenceService(inMemory: true)
        let ctx = result.container.viewContext

        for i in 0..<2 {
            let e = PhotoEntity(context: ctx)
            e.id = "seed-\(i)"
            e.author = "Seed Author \(i)"
            e.imageURL = "https://picsum.photos/id/\(Int.random(in: 0...1000))/400/300"
            e.width = 400
            e.height = 300
            e.order = Int32(i)
            e.createdAt = Date()
        }
        try? ctx.save()
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LightspeedTakeHome")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                if let error = error as NSError? {
                        // Show alert if there's an error
                        Task { @MainActor in
                            AlertPresenter.shared.show("Unable to load saved data. Please try again later.")
                        }
                        print("Core Data error: \(error), \(error.userInfo)")
                    }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceService {
    var backgroundContext: NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
}
