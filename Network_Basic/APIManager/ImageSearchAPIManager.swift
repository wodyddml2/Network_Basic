import UIKit

import Alamofire
import SwiftyJSON

// 클래스 싱글턴 패턴 vs 구조체 싱글턴 패턴
class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = (Int, [String]) -> Void
    
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = EndPoint.imageSearchURL + "query=\(text ?? "과자")&display=20&start=\(startPage)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let totalPage = json["total"].intValue
                
                let list = json["items"].arrayValue.map { $0["link"].stringValue }
            
                
                completionHandler(totalPage, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestLotto(number: Int, _ lottoNo: [UILabel], _ lottoBNo: UILabel) {
//        let lottoUserDefaults = UserDefaults.standard.
//        if
//        
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in 0...lottoNo.count - 1{
                    lottoNo[i].text = String(json["drwtNo\(i + 1)"].intValue)
                    UserDefaults.standard.set(String(json["drwtNo\(i + 1)"].intValue), forKey: "\(number)")
                }
                
                lottoBNo.text = String(json["bnusNo"].intValue)
            case .failure(let error):
                print(error)
            }
        }
    }
}


