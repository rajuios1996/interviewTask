//
//  CoreDataManager.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "SciflareTask")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        context = container.viewContext
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving. \(error.localizedDescription)")
        }
    }
}

