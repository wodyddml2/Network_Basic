
import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = "https://www.apple.com"
    // App Transport Scurity Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        openWebPage(url: destinationURL)
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

extension WebViewViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
