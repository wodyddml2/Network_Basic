
import UIKit

import Alamofire
import SwiftyJSON


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
        searchTableView.rowHeight = 100
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let dateCalculate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let beforeDate = dateFormatter.string(from: dateCalculate ?? Date())
        
        requestBoxOffice(text: beforeDate)
    }
    
    

    func requestBoxOffice(text: String) {
        
        list.removeAll()
        
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue{
                    
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let rank = movie["rank"].stringValue
                    let rankON =  movie["rankOldAndNew"].stringValue
                    
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, movieRank: rank, movieRankON: rankON)
                    
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
        cell.separatorInset.left = 0
        
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle)"
        cell.openDateLabel.text = "\(list[indexPath.row].releaseDate)"
        cell.rankLabel.text = "\(list[indexPath.row].movieRank)"
        cell.newoldRankLabel.text = "\(list[indexPath.row].movieRankON)"
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 20)
        cell.openDateLabel.font = .boldSystemFont(ofSize: 17)
        cell.rankLabel.font = .boldSystemFont(ofSize: 17)
        
        if cell.newoldRankLabel.text == "NEW" {
            cell.newoldRankLabel.textColor = .red
        } else {
            cell.newoldRankLabel.textColor = .blue
        }

        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text ?? "20220801")
    }
}


    

