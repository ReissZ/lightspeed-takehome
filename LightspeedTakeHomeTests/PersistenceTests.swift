//
//  PersistenceTests.swift
//  LightspeedTakeHomeTests
//
//  Created by Reiss Zurbyk on 2025-09-03.
//

import XCTest
import CoreData
@testable import LightspeedTakeHome

final class PersistenceTests: XCTestCase {

    func test_insertAndFetchPhotoEntity_inMemory() throws {
        let persistence = PersistenceController(inMemory: true)
        let ctx = persistence.container.viewContext

        let e = PhotoEntity(context: ctx)
        e.id = "seed-1"
        e.author = "Tester"
        e.imageURL = "https://picsum.photos/id/1/400/300"
        e.width = 400
        e.height = 300
        e.order = 0
        e.createdAt = Date()
        try ctx.save()

        let req: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", "seed-1")
        let fetched = try ctx.fetch(req)

        // Checks
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.author, "Tester")
        XCTAssertEqual(fetched.first?.width, 400)
    }
}
