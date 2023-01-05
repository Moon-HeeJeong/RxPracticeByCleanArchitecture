//
//  RegisterUC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterUC{
    deinit{
        print("deinit \(self)")
    }
    
    let repository: RegisterRP
    
    init(repository: RegisterRP){
        self.repository = repository
    }
    
    func getData(keyword: String?)->RegisterRP.TestResponse{
        return self.repository.callAPI(keyword: keyword)
    }
}
