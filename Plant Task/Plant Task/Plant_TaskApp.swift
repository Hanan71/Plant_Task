//
//  Plant_TaskApp.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 30/05/1448 AH.
//

import SwiftUI

@main
struct Plant_TaskApp: App {
    @StateObject private var viewModel = PlantViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
        }
    }
}
