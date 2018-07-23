import UIKit

class MealTableViewController: UITableViewController {

    fileprivate var meals = [Meal]()
    fileprivate var maxId: Int = 0
    
    let coreData = MealCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        reload()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("error")
        }
        
        let meal = meals[indexPath.row]
        if meal.image == nil {
            meal.image = UIImagePNGRepresentation(UIImage(named: "defaultPhoto")!) as NSData?
        }
        
        if let workImage = meal.image {
            cell.configure(name: meal.name, image: UIImage(data: workImage as Data))
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMeal(id: Int(meals[indexPath.row].id))
            reload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        
        guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
            fatalError("error")
        }
        
        let defaultData = coreData.defaultData(id: maxId + 1)
        guard let selectedMealCell = sender as? MealTableViewCell else {
             mealDetailViewController.meal = defaultData
            return
        }
        
        guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
            fatalError("error")
        }
        
        let selectedMeal = meals[indexPath.row]
        mealDetailViewController.meal = selectedMeal

    }
    
    public func saveMeal(meal: Meal) {
        
        let sameMeal = meals.filter { $0.id == meal.id }
        if sameMeal.isEmpty {
            coreData.save(id: meal.id, name: meal.name!, rating: meal.rating, image: meal.image!)
        } else {
            coreData.update(id: meal.id, name: meal.name!, rating: meal.rating, image: meal.image!)
        }
        reload()
    }
    
    fileprivate func loadSampleMeals() {
        
        let photo1 = UIImagePNGRepresentation(UIImage(named: "meal1")!) as NSData?
        let photo2 = UIImagePNGRepresentation(UIImage(named: "meal2")!) as NSData?
        let photo3 = UIImagePNGRepresentation(UIImage(named: "meal3")!) as NSData?
        
        coreData.save(id: 1, name: "カプレーゼ", rating: 3, image: photo1!)
        coreData.save(id: 2, name: "チキン", rating: 2, image: photo2!)
        coreData.save(id: 3, name: "ミートパスタ", rating: 3, image: photo3!)
        meals =  loadMeals()!
    }

    fileprivate func reload() {
        meals.removeAll()
        
        if let workLoadMeals = loadMeals(), workLoadMeals.count > 0 {
            meals = workLoadMeals
        } else {
            loadSampleMeals()
        }
        tableView.reloadData()
        
        // 追加した時のID再判用
        maxId = Int(meals.reduce(meals[0].id, { max($0, $1.id) }))
        print(maxId)
        
    }
    
    fileprivate func deleteMeal(id: Int) {
        coreData.delete(id: id)
    }
    
    fileprivate func loadMeals() -> [Meal]? {
        return coreData.load()
    }
}
