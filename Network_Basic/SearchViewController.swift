
import UIKit


/*
 swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔/오른팔
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 연결고리 작업 : 테이블 뷰가 해야 할 역할 > 뷰컨에 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // 테이블 뷰가 사용할 테이블 뷰 셀(XIB) 등록
        // XIB: xml Interface Builder <= 예전 Nib
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 20)
        cell.titleLabel.text = "sssss"
        
        
        
        return cell
    }
    
}
