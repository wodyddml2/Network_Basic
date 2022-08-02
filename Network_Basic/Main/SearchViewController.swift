
import UIKit

import Alamofire
import SwiftyJSON

/*
 swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔
 */

class SearchViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // BoxOffice 배열
    var list: [BoxOfficeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 연결고리 작업 : 테이블 뷰가 해야 할 역할 > 뷰컨에 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        // 테이블 뷰가 사용할 테이블 뷰 셀(XIB) 등록
        // XIB: xml Interface Builder <= 예전 Nib
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        requestBoxOffice(text: "20220801")
    }
    
    
//    func configureView() {
//        searchTableView.backgroundColor = .clear
//        searchTableView.separatorColor = .clear
//        searchTableView.rowHeight = 60
//    }
//
//    func configureLabel() {
//
//    }
    
    func requestBoxOffice(text: String) {
        list.removeAll()
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                self.list.removeAll()
                
                let movieNm = json["boxOfficeResult"]["dailyBoxOfficeList"]
                
                
                for i in movieNm.arrayValue{
                    let movie = i["movieNm"].stringValue
                    let openDt = i["openDt"].stringValue
                    let audiAcc =  i["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movie, releaseDate: openDt, totalCount: audiAcc)
                    
                    self.list.append(data)
                }
                
                
                self.searchTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 20)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle) : \(list[indexPath.row].releaseDate)"
        
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text ?? "20220801")
    }
}
