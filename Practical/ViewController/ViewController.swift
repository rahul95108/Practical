
import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var arrData = NSMutableArray()
    var people: [NSManagedObject] = []

    @IBOutlet weak var tbView: UITableView!
    
    // MARK: - UIView Life Cycle Methods -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrData = NSMutableArray()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Fetch Data -
    
    func fetchData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
            for result in people {
                let dict = NSMutableDictionary()
                dict.setValue(result.value(forKey: "name"), forKey: "name")
                dict.setValue(result.value(forKey: "email"), forKey: "email")
                dict.setValue(result.value(forKey: "filepath"), forKey: "filepath")
                self.arrData.add(dict)
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if self.arrData.count > 0 {
            tbView.reloadData()
        }
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        let dict = self.arrData.object(at: indexPath.row) as! NSDictionary
        
        cell.lblName.text = dict.value(forKey: "name") as? String
        cell.lblEmail.text = dict.value(forKey: "email") as? String
        cell.imgView.image = UIImage(contentsOfFile: dict.value(forKey: "filepath") as! String)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        VC.totalCount = indexPath.row + 1
        VC.isUpdate = true
        
        let dict = self.arrData.object(at: indexPath.row) as! NSDictionary
        VC.dictData = dict
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    // MARK: - UIButton Action Methods -
    
    @IBAction func btnAddAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.totalCount = self.arrData.count + 1
        vc.isUpdate = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

