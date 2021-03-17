//
//  DatabaseHelper.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-03-16.
// Name: Mohammed Suleiman Mohamed Al-Falahy    ID: 121083174

import Foundation
import UIKit //so we can access the shared property from UIApplication
import CoreData

//Controller class facilitates communication between views and models
class DatabaseHelper{
    //singleton instance
    private static var shared : DatabaseHelper?
    
    static func getInstance() -> DatabaseHelper{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            //create new singleton instance
            return DatabaseHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "CoffeeOrder"
    //constructor private becz singleton
    private init(context: NSManagedObjectContext){
        self.moc = context
    }
    
    
    //Fetch all the coffees if any in the database
    //return an array of NSManagedObjects of type CoffeeOrder
    public func getAllOrdersFromDb()-> [CoffeeOrder]?{
        let fetchRequest = NSFetchRequest<CoffeeOrder>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOrdered", ascending: false)]
        
        do{
            //try to fetch the request using the managedObjectContext
            let result = try self.moc.fetch(fetchRequest)
            return result as [CoffeeOrder]
            
        }catch let error as NSError{
            print(#function, "Error in fetching data from db \(error)")
        }
        return nil
    }
    
    //Add order to db
    public func addCoffeeOrder(newOrder: Coffee){
        do{
            let newOrderToBeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! CoffeeOrder
            
            //set all attributes of new CoffeeOrder
            newOrderToBeAdded.dateOrdered = Date()
            newOrderToBeAdded.id = UUID()
            newOrderToBeAdded.size = newOrder.size
            newOrderToBeAdded.numOrdered = Int16(newOrder.numOrdered)
            newOrderToBeAdded.type = newOrder.type
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "New order added to Db")
            }
        }catch let error as NSError{
            print(#function, "Can not save data \(error)")
        }

    }
    
    
    //Fetch From Db
    public func searchOrder(id: UUID) -> CoffeeOrder?{
        let fetchRequest = NSFetchRequest<CoffeeOrder>(entityName: ENTITY_NAME)
        let predicateId = NSPredicate(format : "id == %@", id as CVarArg)
        
        //predicate is the WHERE clause
        fetchRequest.predicate = predicateId
        do{
            //try to fetch the fetchRequest
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first
            }
            
        }catch let error as NSError{
            print(#function, "Cannot fetch \(error)")
        }
        return nil
    }
    
    //UPDATE ORDER FROM DB
    public func updateOrder(updatedOrder: CoffeeOrder){
        let fetchedOrder = self.searchOrder(id: updatedOrder.id! as UUID)
        
        if fetchedOrder != nil{
            //order exists
            do{
                fetchedOrder!.type = updatedOrder.type
                fetchedOrder!.size = updatedOrder.size
                fetchedOrder!.numOrdered = Int16(updatedOrder.numOrdered)
                
                try self.moc.save()
                
            }catch let error as NSError{
                print(#function, "Cannot update in Db \(error)")
            }
                        
        }
    }
    
    //DELETE ORDER FROM DB
    public func deleteOrder(id: UUID){
        let fetchedOrder = self.searchOrder(id: id)
        
        if fetchedOrder != nil{
            do{
                self.moc.delete(fetchedOrder!)
                try self.moc.save()
                
            }catch let error as NSError{
                print(#function, "Cannot delete from Db \(error)")
            }
        }
    }
}
