//
//  AlertPresenter.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-03.
//

import SwiftUI

@MainActor
final class AlertPresenter: ObservableObject {
    static let shared = AlertPresenter()

    @Published var isPresented: Bool = false
    @Published var message: String = "Something went wrong."

    func show(_ message: String = "Something went wrong.") {
        self.message = message
        self.isPresented = true
    }
}
