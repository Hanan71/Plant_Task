//
//  Plant.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 12/11/2026.
//

import Foundation

struct PlantItem: Identifiable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var waterAmount: String
    var frequency: String
    var isWatered: Bool = false
}
