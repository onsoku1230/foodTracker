import UIKit
import CoreData

class MealCoreData: NSObject {

    fileprivate let context: NSManagedObjectContext
    
    override init() {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    public func defaultData(id: Int) -> Meal {
        let entity = NSEntityDescription.entity(forEntityName: "Meal", in: context)
        let meals = Meal(entity: entity!, insertInto: context)
        // データ追加
        meals.id = Int16(id)
        meals.name = ""
        meals.rating = 0
        meals.image = UIImagePNGRepresentation(UIImage(named: "defaultPhoto")!) as NSData?
        return meals
    }
    
    public func save(id: Int16, name: String, rating: Int16, image: NSData) {
        let entity = NSEntityDescription.entity(forEntityName: "Meal", in: context)
        context.reset()
        let meals = Meal(entity: entity!, insertInto: context)
        // データ追加
        meals.id = id
        meals.name = name
        meals.rating = rating
        meals.image = image
        // 保存
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    public func update(id: Int16, name: String, rating: Int16, image: NSData) {
        let fetchRequest:NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predict = NSPredicate(format: "id = %d", Int(id))
        fetchRequest.predicate = predict
        
        context.reset()
        let fetchData = try! self.context.fetch(fetchRequest)
        if(!fetchData.isEmpty){
            for i in 0..<fetchData.count{
                fetchData[i].id = id
                fetchData[i].name = name
                fetchData[i].image = image
                fetchData[i].rating = rating
            }
            do{
                try self.context.save()
            }catch{
                print(error)
            }
        }
    }
    
    public func load() -> [Meal] {
        let fetchRequest:NSFetchRequest<Meal> = Meal.fetchRequest()
        var mealsList:Array<Meal> = []
        let fetchData = try! context.fetch(fetchRequest)
        if(!fetchData.isEmpty){
            for i in 0..<fetchData.count{
                let entity = NSEntityDescription.entity(forEntityName: "Meal", in: context)
                guard let meals = NSManagedObject(entity:entity!,insertInto:context) as? Meal else {
                    break
                }
                meals.id = fetchData[i].id
                meals.name = fetchData[i].name
                meals.image = fetchData[i].image
                meals.rating = fetchData[i].rating
                mealsList.append(meals)
            }
        }
        print(mealsList)
        return mealsList
    }
    
    public func delete(id: Int) {
        let fetchRequest:NSFetchRequest<Meal> = Meal.fetchRequest()
        let predict = NSPredicate(format: "%K=%d", "id", id)
        fetchRequest.predicate = predict
        self.context.reset()
        let fetchData = try! self.context.fetch(fetchRequest)
        if(!fetchData.isEmpty){
            for i in 0..<fetchData.count{
                let deleteObject = fetchData[i] as Meal
                context.delete(deleteObject)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
}
