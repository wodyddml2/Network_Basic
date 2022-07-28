
import UIKit

// UIButton, UITextField > Action
// UITextView, UISearchBar, UIPickerView > X
// UIControl
// UIResponderChain > apple Doc, blog             ex. userInputTextView.resignFirstResponder()


class TranslateViewController: UIViewController {

    
    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
    }
}

extension TranslateViewController: UITextViewDelegate {
    // 텍스트의 글자가 변환할 때 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    // 커서(편집)가 시작될 때 호출
    // 텍스트 뷰 글자: placeholder가 글자랑 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("start")
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
//        userInputTextView.text = ""
//        userInputTextView.textColor = .black
    }
    // 편집이 끝났을 때 호출(커서가 없어지는 순간)
    // 텍스트 뷰 글자: 사용자가 아무 글자를 안썼을 시 placeholder가 글자 보이게
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
        print("end")
    }
}
