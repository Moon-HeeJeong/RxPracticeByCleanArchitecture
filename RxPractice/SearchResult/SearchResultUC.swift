//
//  SearchResultUC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultUC: UseCaseType{
    deinit{
        print("deinit \(self)")
    }
    
    var repository: SearchResultRP
    
    required init(repository: SearchResultRP){
        self.repository = repository
    }
    
}
