//
//  LottoViewController.swift
//  Network_Basic
//
//  Created by J on 2022/07/28.
//

import UIKit

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
        
        numberTextField.tintColor = .clear
        
        // inputView는 보통 UITextField,UITextView에서 사용되는 프로퍼티로 일반적으로 get-only이지만 UITextField,UITextView에서 get,set 프로퍼티로 사용 가능 , 키보드를 대체하는 view를 제공하는데 사용.
        numberTextField.inputView = lottoPickerView
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
        numberTextField.text = "\(numberList[row])회차"
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}
