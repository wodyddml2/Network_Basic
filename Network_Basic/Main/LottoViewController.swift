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
    
    var numberList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        numberTextField.delegate = self
        numberTextField.tintColor = .clear
        
        // inputView는 보통 UITextField,UITextView에서 사용되는 프로퍼티로 일반적으로 get-only이지만 UITextField,UITextView에서 get,set 프로퍼티로 사용 가능 , 키보드를 대체하는 view를 제공하는데 사용.
        numberTextField.inputView = lottoPickerView
        numberTextField.textContentType = .oneTimeCode // 살펴보기
        
        let firstDateSetting = DateComponents(year: 2002, month: 12, day: 7, hour: 20, minute: 50)
        let firstDate = Calendar.current.date(from: firstDateSetting)
        let totalDay = Calendar.current.dateComponents([.day], from: firstDate!, to: Date())
        let newRound = (totalDay.day ?? 0) / 7 + 1
        
        numberList.append(contentsOf: Array(1...newRound).reversed())
        
        requestLotto(number: numberList[0])
        numberTextField.text = "\(numberList[0])회차"
       
    }
   
    
    func requestLotto(number: Int) {
        ImageSearchAPIManager.shared.requestLotto(number: number, lottoLabel, lottobnusLabel)
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
