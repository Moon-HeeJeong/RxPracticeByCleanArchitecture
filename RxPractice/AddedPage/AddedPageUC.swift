//
//  AddedPageUC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/05.
//

import Foundation
import RxSwift
import RxCocoa

class AddedPageUC: UseCaseType{
    deinit{
        print("deinit \(self)")
    }
    
    var repository: AddedPageRP
    
    required init(repository: AddedPageRP){
        self.repository = repository
    }
    
}
