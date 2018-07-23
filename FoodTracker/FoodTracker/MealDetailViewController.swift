import UIKit

class MealDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var starCollection: [UIImageView]!
    @IBOutlet weak var imageButton: UIButton!
    
    var meal: Meal = Meal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = meal.name
        textField.text = meal.name
        
        if let workImage = meal.image {
            imageButton.setImage(UIImage(data: workImage as Data), for: .normal)
        }
        
        setCollectionLabel(rating: Int(meal.rating))
    }
    
    @IBAction func tapStar(_ sender: Any) {

        if meal.rating == 5 {
            meal.rating = 0
        } else {
            meal.rating += 1
        }
        setCollectionLabel(rating: Int(meal.rating))
    }
    
    // Mark: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else{
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageButton.setImage(selectedImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSave(_ sender: Any) {
        
        meal.name = textField.text ?? ""
        meal.image = UIImagePNGRepresentation(imageButton.image(for: .normal)!) as NSData?
        
        let mealTableViewController = self.navigationController?.viewControllers[0] as! MealTableViewController
        mealTableViewController.saveMeal(meal: meal)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func tapImage(_ sender: Any) {
        textField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil    )        
    }
    
    fileprivate func setCollectionLabel(rating: Int) {
        _ = starCollection.map { $0.image =  UIImage(named: "emptyStar")}
        for i in 0..<rating {
            starCollection[i].image =  UIImage(named: "highlightedStar")
        }
    }
}
