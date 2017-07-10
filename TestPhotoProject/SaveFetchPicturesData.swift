//
//  SaveFetchPicturesData.swift
//  TestPhotoProject
//
//  Created by Chanchal on 10/07/17.
//  Copyright © 2017 Naxtre. All rights reserved.
//

import UIKit
import CoreData
class SaveFetchPicturesData: NSObject
{
    //MARK: - saveData
    func save(pics: Data) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Pictures",
                                       in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(pics, forKeyPath: "pictures")
        do {
            try managedContext.save()
            print("save")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    //MARK: - fetchDta
    func fetchData() -> NSArray
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
        var  dateCreated : NSArray?
        do {
            let results = try context.fetch(fetchRequest)
            dateCreated = results as NSArray?
            for _datecreated in dateCreated! {
                print(results)
            }
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return dateCreated!
    }
    
}
