
import UIKit

import SwiftyJSON
import Alamofire


class BeerViewController: UIViewController {
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UITextView!
    @IBOutlet weak var beerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beerLabel.text = ""
        beerLabel.textAlignment = .center
        beerLabel.font = UIFont(name: "MYYeongnamnu", size: 17)
        
        beerImage.contentMode = .scaleAspectFit
        beerButton.setTitle("Random", for: .normal)
        beerButton.setTitleColor(.darkGray, for: .normal)
        beerDescription.text = ""
    }
    
    func requestRandomBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let imageURL = URL(string: json[0]["image_url"].string ?? "https://images.punkapi.com/v2/keg.png")
                // try: 예외처리 구문(오류를 낼 수 있음에도 처리)
                let imageData = try? Data(contentsOf: imageURL!)
                
                self.beerLabel.text = json[0]["name"].stringValue
                self.beerImage.image = UIImage(data: imageData!)
                
                self.beerDescription.text = json[0]["description"].stringValue
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func beerButtonClicked(_ sender: UIButton) {
        requestRandomBeer()
    }
    
}
