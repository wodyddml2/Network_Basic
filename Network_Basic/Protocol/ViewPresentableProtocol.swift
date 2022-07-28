import Foundation
import UIKit

/*
 네이밍
 -----Protocol
 -----Delegate
 */

// 프로토콜은 규약이자 필요한 요소를 명세만 할 뿐, 실질적인 구현부는 작성하지 않는다!
// 실질적인 구현은 프로토콜을 채택, 준수한 타입이 구현!
// 클래스, 구조체, 익스텐션, 열거형...
// 클래스는 단일 상속, 프로토콜은 채택 갯수에 제한이 없다!
// @objc optional > 선택적 요청(Optional Requirement)
// 프로토콜 프로퍼티, 프로토콜 메서드

// 프로토콜 프로퍼티: 연산 프로퍼티로 쓰던 저장 프로퍼티로 쓰던 상관 노 / 명세하지 않기에 구현할 때 프로퍼티를 저장이나 연산으로 사용 가능
// 무조건 var로 선언
// 만약에 get을 명시했다면 get 기능만 최소한으로 구현되어 있으면 된다. 즉, 필요한다면 set도 구현해도 된다.
// Get으로 사용할 때 구현부에서 var를 let으로 명시해 줄 수 있다!

// ex. collection 타입도 protocol 문법을 채택

@objc
protocol ViewPresentableProtocol {
    
    var navigationTitleString: String { get set }
    var backgroundColor: UIColor { get }
    
    func configureView()
    
    func configureLabel()
    
    @objc optional func configureTextField()
}

/*
 ex. 테이블 뷰
 */
// @objc optional을 사용하려면 프로토콜에 @objc사용
@objc
protocol JYTableViewProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    
    @objc optional func didSelectRowAt()
}
