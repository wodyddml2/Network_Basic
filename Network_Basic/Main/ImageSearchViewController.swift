import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    var list: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        searchCollectionView.register(UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageSearchCollectionViewCell")
        
        fecthImage()
    }
    
    
    // fetchImage, requestImage, callRequestImage, getImage.. -> response에 따라 네이밍 설정
    // 내일 -> 페이지네이션(pageNation): 다음 데이터들을 효과적으로 보여주기 위함
    // 데이터가 많으면 리소스가 많아 서버에 과한
    // 1. offsetPagenation: 자주 사용 몇 번째로 잘라서 url에 담아 해당 인덱스까지 스크롤 시 표현
    // 2. cursorPagenation: 이것도 자르긴하지만 마지막 데이터를 기반으로 몇 가지를 가져오는 개념 - 중복된 데이터를 막기위함(트위터 등)
    func fecthImage() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = EndPoint.imageSearchURL + "query=\(text ?? "과자")&display=20&start=1"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in json["items"].arrayValue {

//                   let str = i["link"].string?.components(separatedBy: ["\\"]).joined()
                    let imageURL = URL(string: i["link"].stringValue)
                    let imageData = try? Data(contentsOf: imageURL!)
                    
                    self.list.append(imageData!)
                }
               
                self.searchCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.searchImage.image = UIImage(data: list[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 8
        
        return CGSize (width: width / 2.2 , height: width / 3)
    }

}
