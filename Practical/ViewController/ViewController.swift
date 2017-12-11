
import UIKit

class ViewController: UIViewController {
    
    var arrData = NSMutableArray()
    
    // MARK: - UIView Life Cycle Methods -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIButton Action Methods -
    
    @IBAction func btnAddAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.totalCount = self.arrData.count+1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

