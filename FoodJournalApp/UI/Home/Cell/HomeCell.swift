//
//  HomeCell.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import Foundation
import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet private weak var foodImage: UIImageView!
    @IBOutlet private weak var foodTitle: UILabel!
    @IBOutlet private weak var foodDay: UILabel!
    
    func configure(food: FoodModel){
        foodImage.image = UIImage(data: food.image)
        foodTitle.text = food.title
        foodDay.text = food.day
    }
}
