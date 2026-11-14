//
//  RootView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 14/11/2026.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: PlantViewModel

    var body: some View {
        if !viewModel.hasAddedPlant {
            StartView()
        } else if viewModel.plants.isEmpty {
            NoRemindersView()
        } else if viewModel.allWatered {
            AllDoneView()
        } else {
            TodayReminderView()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(PlantViewModel())
}
