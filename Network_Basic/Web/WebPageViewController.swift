import UIKit
import WebKit

class WebPageViewController: UIViewController {

    @IBOutlet weak var urlSearchBar: UISearchBar!
    @IBOutlet weak var webPage: WKWebView!
    
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var gobackButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    
    var destinationURL = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlSearchBar.delegate = self
        
        startWebPage(adress: destinationURL)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButton))
        navigationController?.navigationBar.tintColor = .lightGray
        toolBarStyle(stopButton, "multiply")
        toolBarStyle(gobackButton, "lessthan")
        toolBarStyle(reloadButton, "goforward")
        toolBarStyle(goForwardButton, "greaterthan")
    }
    
    func toolBarStyle(_ button:UIBarButtonItem, _ image:String) {
        button.image = UIImage(systemName: image)
        button.title = ""
        button.tintColor = .lightGray
    }
    
    func startWebPage(adress: String) {
        guard let url = URL(string: adress) else {
            
            return
        }
        let request = URLRequest(url: url)
        webPage.load(request)
    }
   
    @objc func backButton() {
        self.dismiss(animated: true)
    }
    
    @IBAction func stopButtonClicked(_ sender: UIBarButtonItem) {
        webPage.stopLoading()
    }
    @IBAction func gobackButtonClicked(_ sender: UIBarButtonItem) {
        if webPage.canGoBack {
            webPage.goBack()
        }
    }
    @IBAction func reloadButtonClicked(_ sender: UIBarButtonItem) {
        webPage.reload()
    }
    @IBAction func goForwardButtonClicked(_ sender: UIBarButtonItem) {
        if webPage.canGoForward {
            webPage.goForward()
        }
    }
    

}

extension WebPageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startWebPage(adress: searchBar.text ?? destinationURL)
//        searchBar.text = ""
    }
    
}
