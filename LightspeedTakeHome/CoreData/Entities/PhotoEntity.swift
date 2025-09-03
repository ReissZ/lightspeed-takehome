//
//  PhotoEntity.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import Foundation
import CoreData

@objc(PhotoEntity)
public class PhotoEntity: NSManagedObject { }

extension PhotoEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var author: String
    @NSManaged public var imageURL: String
    @NSManaged public var width: Int32
    @NSManaged public var height: Int32
    @NSManaged public var order: Int32
    @NSManaged public var createdAt: Date
}
