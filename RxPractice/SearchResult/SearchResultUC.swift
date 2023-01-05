//
//  SearchResultUC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultUC{
    deinit{
        print("deinit \(self)")
    }
    
    let repository: SearchResultRP
    
    init(repository: SearchResultRP){
        self.repository = repository
    }
    
}
