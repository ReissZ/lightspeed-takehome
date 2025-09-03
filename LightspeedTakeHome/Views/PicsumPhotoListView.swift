//
//  PicsumPhotoListView.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import SwiftUI
import CoreData

struct PicsumPhotoListView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: PhotoListViewModel
    @StateObject private var alertPresenter = AlertPresenter.shared
    @State private var showingAbout = false
    @State private var showSignatureToast = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: PhotoListViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.photos.isEmpty {
                    emptyState
                } else {
                    listView
                }
            }
            .navigationTitle("Picsum Browser")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await viewModel.addRandom() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Label("Add Random", systemImage: "plus.circle.fill")
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .accessibilityIdentifier("addRandomButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAbout = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("About")
                }
            }
            .sheet(isPresented: $showingAbout) { AboutView() }
            .task { viewModel.load() }
            .refreshable { viewModel.load() }
        }
        .alert("Error", isPresented: $alertPresenter.isPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertPresenter.message)
        }
    }

    private var listView: some View {
        List {
            ForEach(viewModel.photos, id: \.objectID) { photo in
                PhotoRowView(photo: photo)
                    .swipeActions {
                        Button(role: .destructive) {
                            if let idx = viewModel.photos.firstIndex(of: photo) {
                                viewModel.delete(at: IndexSet(integer: idx))
                            }
                        } label: { Label("Delete", systemImage: "trash") }
                    }
            }
            .onMove(perform: viewModel.move)
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled").font(.system(size: 48))
            Text("No saved photos yet").font(.headline)
            Text("Tap “Add Random” to fetch and save a random image from Picsum.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview("PicsumPhotoListView – Mocked") {
    let persistence = PersistenceService(inMemory: true)
    let ctx = persistence.container.viewContext

    for i in 0..<2 {
        let e = PhotoEntity(context: ctx)
        e.id = "seed-\(i)"
        e.author = ["Annie Leibovitz", "Dorothea Lange", "Henri Cartier-Bresson"].randomElement()!
        e.imageURL = "https://picsum.photos/id/\(Int.random(in: 0...1000))/400/300"
        e.width = 400
        e.height = 300
        e.order = Int32(i)
        e.createdAt = Date()
    }
    try? ctx.save()

    return PicsumPhotoListView(context: ctx)
        .environment(\.managedObjectContext, ctx)
}
