//
//  AddedPageVM.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/05.
//

import Foundation
import RxSwift
import RxCocoa

class AddedPageVM: ViewModelType{
    
    deinit{
        print("deinit \(self)")
    }
    
    
    struct Input: InputType{
        var closeBtnTap: Observable<Void>
    }
    
    struct Output: OutputType{
    }
    
//    weak var coordinator: AddedPageCoordinator?
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv = PublishSubject<Any?>()
    
//    var usecase: AddedPageUC
    weak var coordinator: AddedPageCoordinator?
    var usecase: AddedPageUC
    let dBag = DisposeBag()
    
    init(coordinator: AddedPageCoordinator, usecase: AddedPageUC){
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.setUpGift(disposeBag: dBag)
    }
    
    
    func transformToOutput(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        
        input.closeBtnTap
            .bind {
                print("AddPage VM --> SearchResult VM deliver gift")
                self.giftDeliverObv.onNext("AddPage 종료")
//                self.giftDeliverObv.onNext("jjjjjj")
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output()
    }
    
}
