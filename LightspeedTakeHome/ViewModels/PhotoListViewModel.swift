//
//  PhotoListViewModel.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import Foundation
import CoreData
import Combine

@MainActor
final class PhotoListViewModel: ObservableObject {

    // Published Core Data PhotoEntity
    @Published private(set) var photos: [PhotoEntity] = []
    @Published var isLoading = false

    private let context: NSManagedObjectContext
    private let api: APIServiceProtocol

    init(context: NSManagedObjectContext, api: APIServiceProtocol = APIService()) {
        self.context = context
        self.api = api
    }

    func load() {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(PhotoEntity.order), ascending: true),
            NSSortDescriptor(key: #keyPath(PhotoEntity.createdAt), ascending: true)
        ]
        do {
            photos = try context.fetch(request)
        } catch {
            print("Failed to fetch photos: \(error)")
            photos = []
        }
    }

    // Fetches random remote item, persists and adds to list
    func addRandom() async {
        guard !isLoading else { return }
            isLoading = true; defer { isLoading = false }
        do {
            let remote = try await api.fetchPhotos(page: Int.random(in: 1...10), limit: 30)
            guard let random = remote.randomElement() else { return }

            let nextOrder: Int32 = (photos.last?.order ?? -1) + 1

            let bg = PersistenceController.shared.backgroundContext
            try await bg.perform {
                let req: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
                req.predicate = NSPredicate(format: "id == %@", random.id)
                req.fetchLimit = 1
                if try bg.count(for: req) > 0 { return }

                let e = PhotoEntity(context: bg)
                e.id = random.id
                e.author = random.author
                e.imageURL = random.download_url
                e.width = Int32(random.width)
                e.height = Int32(random.height)
                e.order = nextOrder
                e.createdAt = Date()

                try bg.save()
            }

            load()
        } catch {
            AlertPresenter.shared.show("Couldn’t add a photo. Please try again.")
            print("addRandom error: \(error)")
        }
    }

    // MARK: - Delete

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let object = photos[index]
            context.delete(object)
        }
        saveAndResequenceOrders()
    }

    // MARK: - Reorder

    func move(from source: IndexSet, to destination: Int) {
        var arr = photos
        arr.move(fromOffsets: source, toOffset: destination)

        // Resequence orders to be stable and increasing from 0...
        for (idx, item) in arr.enumerated() {
            item.order = Int32(idx)
        }
        do {
            try context.save()
            photos = arr
        } catch {
            print("Failed to save after move: \(error)")
            context.rollback()
            load()
        }
    }

    // MARK: - Helpers

    private func persist(_ dto: PhotoDTO, order: Int32) throws {
        if try exists(id: dto.id) { return }

        let entity = PhotoEntity(context: context)
        entity.id = dto.id
        entity.author = dto.author
        entity.imageURL = dto.download_url
        entity.width = Int32(dto.width)
        entity.height = Int32(dto.height)
        entity.order = order
        entity.createdAt = Date()

        try context.save()
    }

    private func exists(id: String) throws -> Bool {
        let req: NSFetchRequest<NSFetchRequestResult> = PhotoEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id)
        req.fetchLimit = 1
        let count = try context.count(for: req)
        return count > 0
    }

    private func saveAndResequenceOrders() {
        // After deletion, compact order to keep indices contiguous
        for (idx, item) in photos.enumerated() {
            item.order = Int32(idx)
        }
        do {
            try context.save()
            load()
        } catch {
            print("Failed to save after delete: \(error)")
            context.rollback()
            load()
        }
    }
}
