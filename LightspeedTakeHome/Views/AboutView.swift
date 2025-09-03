//
//  AboutView.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-03.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.aperture")
                .font(.system(size: 44))
                .symbolRenderingMode(.hierarchical)

            Text("Picsum Browser")
                .font(.title2).bold()

            Text("Built with SwiftUI, async/await, and Core Data.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Divider().padding(.vertical, 4)

            Text("Crafted by Reiss Zurbyk")
                .font(.headline)

            // Replace with your links
            HStack(spacing: 20) {
                Link("GitHub", destination: URL(string: "https://github.com/reissz")!)
                Link("LinkedIn", destination: URL(string: "https://www.linkedin.com/in/reiss-zurbyk/")!)
            }
            .font(.subheadline)

            Spacer()
            Text("© \(Calendar.current.component(.year, from: Date())) Reiss Zurbyk")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}
