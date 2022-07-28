
import UIKit

class WebStartViewController: UIViewController {
    @IBOutlet weak var webButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webButton.setTitle("Web Start!", for: .normal)
        webButton.setTitleColor(.black, for: .normal)
        webButton.backgroundColor = .green
        
        
    }
    
  

    
    @IBAction func webButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Web", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "WebPageViewController") as? WebPageViewController else {
            return
        }
        
        
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
    
}
