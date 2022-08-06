
import UIKit

class LocationViewController: UIViewController{

    
    @IBOutlet weak var imageView: UIImageView!
    
    // Notification 1.
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        requestAuthorization()
        
    }
    @IBAction func downlaodImage(_ sender: UIButton) {
        let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
        print("1", Thread.isMainThread)

        // DispatchQueue: 일을 분배하는 역할
        // .global(): 여러 곳에 분배?
        // async: 비동기 차례대로 말고 한번에?
        // main: 직렬화
        
        DispatchQueue.global().async { // 동시에 여러 작업 가능하게 해줘!
            print("2", Thread.isMainThread)
            let data = try! Data(contentsOf: URL(string: url)!)
            
            let image = UIImage(data: data)
            // iOS에서 UI 작업은 main thread에서 작용하게 하라
            DispatchQueue.main.async {
                self.imageView.image = image
                print("3", Thread.isMainThread)
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        self.sendNotification()
    }
    
    
    // Notification 2. 권한 요청
    func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert,.badge,.sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { sucess, error in
            if sucess {
                self.sendNotification()
            }
        }
    }
    // Notification 3. 권한 허용한 사용자에게 알림 요청(언제? 어떤 컨텐츠??)
    // iOS 시스템에서 알림을 담당 > 알림 등록
    
    /*
     - 권한 허용해야 알림이 온다.
     - 권한 허용 문구 시스템적으로 최초 한 번 뜬다.
     - 허용이 안된 경우 애플 설정으로 유도해야하는 코드 구성
     
     - 기본적으로 알림은 포그라운드에서 수신되지 않는다.
     - 로컬 알림에서 60초 이상 반복 가능 / 갯수 제한 64개 / 커스텀 사운드
     
     앱의 생명주기를 이용해서 적절한 곳에서 조절 (아래는 임의로 하는거)
     1. 벳지 제거? > sceneDelegate에서 active부분
     2. 노티 제거? > 노티의 기간은? > 카톡 vs 잔디 > 언제 삭제?
     3. 포그라운드 수신? > 앱 딜리게이트
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면??
     - 포그라운드 수신, 특정 화면에서는 안받고 특정 조건에서만 포그라운드 수신을 받고 싶다면?
     - iOS 15 집중모드 등 5-6 우선순위 존재!
     */
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "다마고치를 밥 좀 주세요"
        notificationContent.body = "오늘 행운의 숫자는 \(Int.random(in: 0...9))"
        notificationContent.badge = 40
        
        // 언제 보낼 것인가 - 1. 시간 간격, 2. 켈린더, 3. 위치에 따라 설정 가능.
        // 시간 간격에서는 60초 이상 설정해야 반복 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
//        var dateComponent = DateComponents()
//        dateComponent.minute = 16
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
//
        // 알림 요청
        // identifier:
        // 만약에 알림 관리할 필요 없다면 알림 클릭하면 앱을 켜주는 정도. - \(Date())
        // 만약 알리 관리를 할 필요가 있다면 +1, 고유이름, 규칙
        let request = UNNotificationRequest(identifier: "jy", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
}
