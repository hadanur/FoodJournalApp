//
//  CreateFoodVMü.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import Foundation
import UIKit

protocol CreateFoodVMDelegate: AnyObject {
    func saveButtonTapped(title: String, day: String, image: UIImage)
    func saveSuccess()
    func error()
}

class CreateFoodVM {
    weak var delegate: CreateFoodVMDelegate?
    
    func saveFood(title: String, day: String, image: UIImage){
        if CoreDataManager.shared.saveFood(title: title, day: day, image: image) == true {
            delegate?.saveSuccess()
        } else {
            delegate?.error()
        }
    }
}
