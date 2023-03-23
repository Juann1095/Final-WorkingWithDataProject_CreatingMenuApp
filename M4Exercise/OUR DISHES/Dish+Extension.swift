import Foundation
import CoreData
import SwiftUI


extension Dish {

    static func createDishesFrom(menuItems:[MenuItem],
                                 _ context:NSManagedObjectContext) {
        
        for item in menuItems {
            
            if !checkExist (item: item, context) {
                let newDish = Dish(context: context)
                newDish.name = item.title
                
                newDish.price = Float(item.price)!
                
                saveDatabase(context: context)
           }
        }
        
        
        
    }
    
    
    static func checkExist(item : MenuItem ,  _ context:NSManagedObjectContext) -> Bool {
        @FetchRequest(
            sortDescriptors:[
            ],
            animation: .default)
        var dishes: FetchedResults<Dish>
        
        
        for dish in dishes {
            if dish.name == item.title{
                return true
            }
        }
        
        return false
        
    }
    
    
        

    
   static func saveDatabase(context:NSManagedObjectContext) {
        guard context.hasChanges else { return}
        do {
            try context.save()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    
    
}
