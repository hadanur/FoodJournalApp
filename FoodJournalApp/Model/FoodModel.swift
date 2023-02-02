//
//  FoodModel.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import Foundation

struct FoodModel: Codable {
    let id : UUID
    let title: String
    let day: String
    let image: Data
}
