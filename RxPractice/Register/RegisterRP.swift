//
//  RegisterRP.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/20.
//

import Foundation
import RxCocoa
import RxSwift
import MHTools
import Alamofire

struct TestInfo: Model_P{
    struct ResultList: Model_P{
        let ipadScreenshotUrls: [String]
    }
    
    var resultCount: Int?
    var results: [ResultList]?
}

struct ResultList: Model_P{
    let ipadScreenshotUrls: [String]
}

class APIConfig: MH_APIConfig{
    var headers: HTTPHeaders?{
        ["api-user-agent" : "LF_APP_iOS:phone/2.7.0/iPhone13,4/iOS:16.0"]
    }

    var baseURL: String{
        "https://itunes.apple.com/"
    }
}

struct APIResponse<DataType: Model_P>: Response_P{
    
    var responseType: ResponseType
    var data: DataType?
    var resultCount: Int?
    var results: [ResultList]?
    
    init(responseType: ResponseType, data: DataType?) {
        self.responseType = responseType
        self.data = data
    }

    enum CodingKeys: CodingKey{
        case resultCount
        case results
    }

    public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.responseType = .ok(message: "")
        
        self.data = try? decoder.container(keyedBy: CodingKeys.self) as? DataType
        self.resultCount = try? container.decode(Int.self, forKey: .resultCount)
        self.results = try? container.decode([ResultList].self, forKey: .results)
        
//        let status = try container.decode(Int.self, forKey: .status)
//        let message = try? container.decode(String.self, forKey: .message)
//
//        self.responseType = status == 200 ? .ok(message: message) : .error(code: status, message: message)
//        self.data = try? container.decode(DataType.self, forKey: .data)
    }
//
//    init(responseType: ResponseType, data: DataType?){
//        self.responseType = responseType
//        self.data = data
//    }
}

struct TestAPI: MH_APIInfo{

    typealias DataType = TestInfo
    typealias ResponseType = APIResponse<DataType>

    let keyword: String?
    var config: MH_APIConfig?
    var short: String{
        if let keyword = keyword{
            return "search?term=\(keyword)&media=software"
        }else{
            return "search?term=''&media=software"
        }
    }

    var method: HTTPMethod{
        .get
    }

    var parameters: Parameters?


    init(keyword: String?, config: MH_APIConfig? = nil){
        self.keyword = keyword
        self.config = config
    }
}

class APITest: MH_API{

    var sessionConfig: URLSessionConfiguration? = {
        nil
    }()

    var trustManager: ServerTrustManager? = {
        nil
    }()

    var session: Session = Session.default
    //{
//        if let config = self.sessionConfig{
//            if let manager = self.trustManager{
//                return Session(configuration: config, serverTrustManager: manager)
//            }else{
//                return Session(configuration: config)
//            }
//        }else{
//            return Session()
//        }
//        Session
   // }()
}


protocol RepositoryType{
    
}
class RegisterRP: RepositoryType{
    deinit{
        print("deinit \(self)")
    }
    
    typealias TestResponse = Observable<TestAPI.ResponseType>
    
    var api: APITest
    var dBag = DisposeBag()
    
    init(){
        self.api = APITest()
    }
    
    func callAPI(keyword: String?)->TestResponse{
        return self.api.callByRx(TestAPI(keyword: keyword, config: APIConfig()))
    }
}

enum APICALLERROR: Error{
    case noData
}
