//
//  CoreData Manager.swift
//  FoodJournalApp
//
//  Created by Hakan Adanur on 2.02.2023.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    func saveFood(title: String, day: String, image: UIImage) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBody = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context)
        
        newBody.setValue(title, forKey: "title")
        newBody.setValue(UUID(), forKey: "id")
        newBody.setValue(day, forKey: "day")
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        
        newBody.setValue(imageData, forKey: "image")

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func getData() -> [FoodModel]? {
        var foods = [FoodModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                
                if let title = result.value(forKey: "title") as? String,
                   let id = result.value(forKey: "id") as? UUID,
                   let image = result.value(forKey: "image") as? Data,
                   let day = result.value(forKey: "day") as? String {
                    let food = FoodModel(id: id, title: title, day: day, image: image)
                    foods.append(food)
                }
            }
            return foods
        } catch {
            print("error")
            return nil
        }
    }
    
    func deleteFood(from data: [FoodModel], at index: Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        let idString = data[index].id.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        if let results = try? context.fetch(fetchRequest) {
            for result in results as! [NSManagedObject] {
                context.delete(result)
            }
            
            do {
                try context.save()
            } catch {
                return false
            }
            
            return true
        }
        
        return false
    }
}
