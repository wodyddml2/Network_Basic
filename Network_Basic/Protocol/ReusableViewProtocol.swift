
import UIKit

protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get }
}



extension UIViewController: ReusableViewProtocol {
    // extension: 저장 프로퍼티는 사용 불가
    static var reuseIdentifier: String {
            return String(describing: self)
    }// ex. LocationViewController.self 메타 타입 => "LocationViewController"
    
}

extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
            return String(describing: self)
    }
}
