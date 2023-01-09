//
//  RegisterUC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol UseCaseType{
    associatedtype T: RepositoryType
    
    var repository: T { get set }
    
    init(repository: T)
}

class RegisterUC: UseCaseType{
    deinit{
        print("deinit \(self)")
    }
    
    var repository: RegisterRP
    
    required init(repository: RegisterRP){
        self.repository = repository
    }
    
    func getData(keyword: String?)->RegisterRP.TestResponse{
        return self.repository.callAPI(keyword: keyword)
    }
}
