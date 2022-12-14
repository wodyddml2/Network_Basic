
import UIKit

import Alamofire
import SwiftyJSON

// UIButton, UITextField > Action
// UITextView, UISearchBar, UIPickerView > X
// UIControl
// UIResponderChain > apple Doc, blog             ex. userInputTextView.resignFirstResponder()

// UIResponder - 이벤트에 응답하고 처리하기 위한 인터페이스

 

class TranslateViewController: UIViewController {

    
    
    @IBOutlet weak var userInputTextView: UITextView!
    
    @IBOutlet weak var attachmentTextview: UITextView!
    
    @IBOutlet weak var translateButton: UIButton!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 입력하세요."
    // NSTextAttachment: 텍스트 첨부 개체를 만듬 - 이미지도 포함 시킬 수 있다.
//    let imageAttachment = NSTextAttachment()
//    let atrributedString = NSMutableAttributedString(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        attachmentTextview.text = ""
//        userInputTextView.dataDetectorTypes = .link
        userInputTextView.textColor = .lightGray
        attachmentTextview.textColor = .lightGray
        
        userInputTextView.textAlignment = .center
        attachmentTextview.textAlignment = .center
        // 텍스트 편집 기능을 꺼놔야 탭이 가능
//        userInputTextView.isEditable = false
        
        userInputTextView.font = UIFont(name: "Galmuri9-Regular", size: 20)
        attachmentTextview.font = UIFont(name: "Galmuri9-Regular", size: 20)
        
        attachmentTextview.isEditable = false
        
        translateButton.setTitle("한/영", for: .normal)
        translateButton.setTitleColor(.black, for: .normal)
//        translateLabel.numberOfLines = 0
//
//        imageAttachment.image = UIImage(named: "3-9")
//        // NSAttributedString: 문자 범위에 적용되는 문자열 및 관련 속성을 관리
//        atrributedString.append(NSAttributedString(attachment: imageAttachment))
//        atrributedString.append(NSAttributedString(string: "attachment와 attributedString"))
//        // attributedText: 스타일이 지정된 텍스트
//        attachmentTextview.attributedText = atrributedString
    }
    
    func requestTranslateData() {
        let url = EndPoint.translateURL
        
        let parameter = ["source": "ko", "target": "en", "text": userInputTextView.text ?? ""]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.attachmentTextview.text = json["message"]["result"]["translatedText"].stringValue
                } else {
                    self.attachmentTextview.text = json["errorMessage"].stringValue
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        requestTranslateData()
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
        if userInputTextView.textColor == .lightGray {
            userInputTextView.text = nil
            userInputTextView.textColor = .black
        }
        
    }
    // 편집이 끝났을 때 호출(커서가 없어지는 순간)
    // 텍스트 뷰 글자: 사용자가 아무 글자를 안썼을 시 placeholder가 글자 보이게
    func textViewDidEndEditing(_ textView: UITextView) {
        if userInputTextView.text.isEmpty {
            userInputTextView.text = textViewPlaceholderText
            userInputTextView.textColor = .lightGray
        }
        print("end")
    }
}
