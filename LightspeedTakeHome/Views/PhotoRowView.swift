//
//  PhotoRowView.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import SwiftUI

struct PhotoRowView: View {
    let photo: PhotoEntity

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: photo.imageURL)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle().opacity(0.08)
                        ProgressView()
                    }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    ZStack {
                        Rectangle().opacity(0.08)
                        Image(systemName: "photo")
                    }
                @unknown default:
                    Color.gray.opacity(0.1)
                }
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityLabel("Photo")

            Text(photo.author)
                .font(.headline)
                .lineLimit(1)

            Spacer()
        }
        .contentShape(Rectangle())
    }
}
