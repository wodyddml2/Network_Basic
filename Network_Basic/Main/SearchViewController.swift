import UIKit

import RealmSwift
import Alamofire
import SwiftyJSON
import JGProgressHUD


class SearchViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let localRealm = try! Realm()
    
    var taskList: Results<UserMovie>?
    
    let hud = JGProgressHUD()
    
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
        dateFormatter.dateFormat = "yyyyMMdd" // YYYYMMdd 찾아볼 것
        
        let dateCalculate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let beforeDate = dateFormatter.string(from: dateCalculate ?? Date())
        
//        taskList = localRealm.objects(UserMovie.self)
        // 네트워크 통신: 서버 점검 등 대한 예외처리
        // 네트워크 느린 환경 테스트
        // 실기기 테스트 시 Condition 조절 가능!!
        // 시뮬도 가능 (추가 설치)
        requestBoxOffice(text: beforeDate)
 
    }
    
    

    func requestBoxOffice(text: String) {
        hud.show(in: view)
        
        taskList = nil
        
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"

        if localRealm.objects(UserMovie.self).filter("dateID == %@", "\(text)").isEmpty {
            AF.request(url, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
    //                print("JSON: \(json)")
                    
                    let task = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue.map {
                        UserMovie(rank: $0["rank"].stringValue, rankON: $0["rankOldAndNew"].stringValue, movieTitle: $0["movieNm"].stringValue, openDate: $0["openDt"].stringValue, dateID: text)
                    }
                    
                    try! self.localRealm.write {
                        
                        self.localRealm.add(task)
                        self.taskList = self.localRealm.objects(UserMovie.self).filter("dateID == %@", "\(text)")
                        print(task)
                    }

                    self.searchTableView.reloadData()
                    self.hud.dismiss()

                    
                case .failure(let error):
                    self.hud.dismiss()
                    print(error)
                }
            }
        } else {
            taskList = localRealm.objects(UserMovie.self).filter("dateID == %@", "\(text)")
            
            self.searchTableView.reloadData()
            self.hud.dismiss()
        }
        

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset.left = 0
        
        cell.titleLabel.text = "\(taskList?[indexPath.row].movieTitle ?? "")"
        cell.openDateLabel.text = "\(taskList?[indexPath.row].openDate ?? "")"
        cell.rankLabel.text = "\(taskList?[indexPath.row].rank ?? "")"
        cell.newoldRankLabel.text = "\(taskList?[indexPath.row].rankON ?? "")"
        
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


    

