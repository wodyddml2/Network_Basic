import Foundation

//enum StoryboardName: String {
//    case Main
//    case Search
//    case Setting
//}

struct APIKey {
    static let BOXOFFICE = "e3cc5aeebee93875abda8383d8afec3a"
    
    static let NAVER_ID = "LE_zHIouxIVT6PZA1wyr"
    static let NAVER_SECRET = "3iPFJCPSAm"
}

struct EndPoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
}
struct StoryboardName {
    // 접근 제어를 통해 초기화 방지
    private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}

/*
 1. struct type property vs enum type property => 인스턴스 생성 방지
    구조체에 타입 프로퍼티를 써도 인스턴스 생성을 안할 수 있지만 협업 시 인스턴스를 생성 할 수 있다. but private init()을 사용하면 열거형 타입 프로퍼티와 같지만 귀찮다고한다..ㅎㅎㅎ
 2. enum case vs enum static => 중복 네임들을 하드코딩 할 수 있는가 case는 제약이 많다.
 
 */

//enum StroyboardName {
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//}

//enum FontName: String {
//    case title = "SanFransisco"
//    case body = "SanFransisco"
//    case caption = "AppleSandol"
//}
