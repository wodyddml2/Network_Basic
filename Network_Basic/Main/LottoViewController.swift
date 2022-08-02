import UIKit

// 1. import
import SwiftyJSON
import Alamofire


class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!

    @IBOutlet var lottoLabel: [UILabel]!
    @IBOutlet weak var lottobnusLabel: UILabel!
    
    
    var lottoPickerView = UIPickerView()
    // 코드로 뷰를 만드는 기능이 훨씬 많다!
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        numberTextField.delegate = self
        numberTextField.tintColor = .clear
        
        // inputView는 보통 UITextField,UITextView에서 사용되는 프로퍼티로 일반적으로 get-only이지만 UITextField,UITextView에서 get,set 프로퍼티로 사용 가능 , 키보드를 대체하는 view를 제공하는데 사용.
        numberTextField.inputView = lottoPickerView
        numberTextField.textContentType = .oneTimeCode // 살펴보기
        print(DateFormatter().string(from: Date()))
//        DateFormatter().calendar.w
        requestLotto(number: numberList[0])
        numberTextField.text = "\(numberList[0])회차"
    }
    
    func requestLotto(number: Int) {
        
        // AF: 200~299 성공 status code
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                // int는 옵셔널, intValue는 옵셔널 x
                for i in 0...self.lottoLabel.count - 1{
                    self.lottoLabel[i].text = String(json["drwtNo\(i + 1)"].intValue)
                }
                
                self.lottobnusLabel.text = String(json["bnusNo"].intValue)
            case .failure(let error):
                print(error)
            }
        }
    }
}
// delegate는 기능부분 , datasource는 data를 주고받음으로써 ;;
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
        numberTextField.text = "\(numberList[row])회차"
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}

extension LottoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = true
    }
}
