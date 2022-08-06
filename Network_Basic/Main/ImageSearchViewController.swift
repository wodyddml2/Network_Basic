import UIKit

import Alamofire
import SwiftyJSON


class ImageSearchViewController: UIViewController {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var list: [String] = []
    
    // 네트워크 요청할 시작 페이지 넘버
    var startPage = 1
    var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self // 페이지 네이션
        searchBar.delegate = self
        
        searchCollectionView.register(UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageSearchCollectionViewCell")
        
    }
    
    
    // fetchImage, requestImage, callRequestImage, getImage.. -> response에 따라 네이밍 설정
    // 내일 -> 페이지네이션(pageNation): 다음 데이터들을 효과적으로 보여주기 위함
    // 데이터가 많으면 리소스가 많아 서버에 과한
    // 1. offsetPagenation: 자주 사용 몇 번째로 잘라서 url에 담아 해당 인덱스까지 스크롤 시 표현
    // 2. cursorPagenation: 이것도 자르긴하지만 마지막 데이터를 기반으로 몇 가지를 가져오는 개념 - 중복된 데이터를 막기위함(트위터 등)
    func fecthImage(query: String) {
        // show
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, list in
            self.totalPage = totalCount
            self.list.append(contentsOf: list)
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
            
            //dismiss
        }
    }
}


extension ImageSearchViewController: UISearchBarDelegate {
    // 검색 단어가 바뀔 수 있음
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            
//            searchCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
            
            fecthImage(query: text)
        }
    }
    
    // 취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        searchCollectionView.reloadData()
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // 서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}


// 페이지네이션 방법3. 용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적
// 셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수 있고, 필요하지 않다면 데이터를 취소할 수 있음.
// iOS10 이상, 스크롤 성능 향상.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalPage {
                startPage += 20
                fecthImage(query: searchBar.text!)
            }
        }
        
        print("=====\(indexPaths)")
        
    }
    
    // 취소: 사용자가 엄청빠르게 드래그 했을때
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("취소====\(indexPaths)")
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
        let url = URL(string: list[indexPath.row])
        let data = try? Data(contentsOf: url!)
        cell.searchImage.image = UIImage(data: data!)
        
        return cell
    }
    // 페이지네이션 방법 1. 컬렉션 뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막 셀에 사용자가 위치해있는 지 명확하게 확인하기가 어려움
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // 페이지네이션 방법 2. UIScrollViewDelegateProtocol 활용
    // 테이블뷰 or 컬렉션뷰는 스크롤 뷰를 상속받고 있어서, 스크롤 뷰를 프로토콜로 사용 가능
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y) // 총 스크롤 뷰의 아래 y위치
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 8
        
        return CGSize (width: width / 2.2 , height: width / 3)
    }

}
