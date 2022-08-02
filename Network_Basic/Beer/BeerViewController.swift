
import UIKit

import SwiftyJSON
import Alamofire


class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var beerCollectionView: UICollectionView!
    
    var beerList: [BeerInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        beerLabel.text = ""
//        beerLabel.textAlignment = .center
//        beerLabel.font = UIFont(name: "MYYeongnamnu", size: 17)
//
//        beerImage.contentMode = .scaleAspectFit
//        beerButton.setTitle("Random", for: .normal)
//        beerButton.setTitleColor(.darkGray, for: .normal)
//        beerDescription.text = ""
//
        beerCollectionView.register(UINib(nibName: BeerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BeerCollectionViewCell.reuseIdentifier)
        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        
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
                let nameData = json[0]["name"].stringValue
                let descriptionData = json[0]["description"].stringValue
                
                self.beerList.append(BeerInfo(beerName: nameData, beerPost: imageData!, beerStory: descriptionData))
                self.beerCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func beerButtonClicked(_ sender: UIButton) {
        requestRandomBeer()
    }
   
}

extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.reuseIdentifier, for: indexPath) as? BeerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.beerImage.image = UIImage(data: beerList[indexPath.row].beerPost)
        cell.beerLabel.text = beerList[indexPath.row].beerName
        cell.beerDescription.text = beerList[indexPath.row].beerStory
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 10
        
        return CGSize(width: width, height: width / 3)
    }
    
}
