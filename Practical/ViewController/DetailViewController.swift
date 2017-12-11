
import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var totalCount = NSInteger()
    let imagePicker = UIImagePickerController()
    
    // MARK: - UIView Life Cycle Methods -

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIButton Action Methods -
    
    @IBAction func btnAddPhotoAction(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAction(){
        checkValue()
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.contentMode = .scaleAspectFit
            imgView.image = pickedImage
            
            btnAddPhoto.setTitle("", for: UIControlState.normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Email-id Validation -
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - Check Value -
    
    func checkValue(){
        if (txtName.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Alert", message:"Please Provide Name.", preferredStyle: UIAlertControllerStyle.alert)
            let confirmed = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
    
            
            alertController.addAction(confirmed)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (txtEmail.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Alert", message:"Please Provide Email.", preferredStyle: UIAlertControllerStyle.alert)
            let confirmed = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            
            alertController.addAction(confirmed)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (!isValidEmail(testStr: txtEmail.text!)){
            let alertController = UIAlertController(title: "Alert", message:"Please Provide Valid Email.", preferredStyle: UIAlertControllerStyle.alert)
            let confirmed = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            
            
            alertController.addAction(confirmed)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            addData()
        }
    }
    
    // MARK: - Add Core Data -
    
    func addData(){
        let strName = String(format: "image%x.jpg",totalCount)
        saveImage(str: strName)
    }
    
    func saveImage(str:String) {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(str)
            print(fileURL)
            if let imageData = UIImageJPEGRepresentation(imgView.image!, 0.5) {
                try imageData.write(to: fileURL)
            }
            strData(str: str)
        } catch {
            print(error)
        }
    }
    
    func strData(str:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(txtName.text, forKey: "name")
        person.setValue(txtEmail.text, forKey: "email")
        person.setValue(str, forKey: "filepath")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextfield Delegate Methods -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
