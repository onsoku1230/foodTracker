import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var id: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16

}
