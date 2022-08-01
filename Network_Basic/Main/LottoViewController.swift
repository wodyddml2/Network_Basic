//
//  LottoViewController.swift
//  Network_Basic
//
//  Created by J on 2022/07/28.
//

import UIKit
// 1. import
import SwiftyJSON
import Alamofire


class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
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
        
    }
    
    func requestLotto(number: Int) {
        
        // AF: 200~299 성공 status code
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                // int는 옵셔널, intValue는 옵셔널 x
                let bnus = json["bnusNo"].intValue
                print(bnus)
                
                let drwNoDate = json["drwNoDate"].stringValue
                self.numberTextField.text = drwNoDate
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
//        numberTextField.text = "\(numberList[row])회차"
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
