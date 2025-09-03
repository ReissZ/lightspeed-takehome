//
//  PhotoDTO.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import Foundation

// MARK: - Photo Data Transfer Object

struct PhotoDTO: Codable, Identifiable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
