//
//  CoreDataManager.swift
//  In*
//
//  Created by Mohammad Sulthan on 11/08/22.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()

    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "In")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func cancelPendingOrder(item: Order) {
        let order = item
        
        order.status = "cancelled"
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to update pending order, \(error)")
        }
    }
    
    func completePendingOrder(item: Order) {
        let order = item
        
        order.status = "completed"
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to update pending order, \(error)")
        }
    }
}
