//
//  HomeVM.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import Foundation
import UIKit

protocol HomeVMDelegate: AnyObject {
    func bringDataOnSuccess()
    func bringDataOnError()
    func deleteDataOnSuccess(at index: Int)
    func deleteDataOnError()
}

class HomeVM {
    var foods = [FoodModel]()
    weak var delegate : HomeVMDelegate?
    
    func viewDidLoad(){
        if let foods = CoreDataManager.shared.getData() {
            self.foods = foods
            delegate?.bringDataOnSuccess()
        }
    }
    
    func deleteData(from data: [FoodModel], at index: Int) {
        if CoreDataManager.shared.deleteFood(from: data, at: index) {
            delegate?.deleteDataOnSuccess(at: index)
        } else {
            delegate?.deleteDataOnError()
        }
    }
}
