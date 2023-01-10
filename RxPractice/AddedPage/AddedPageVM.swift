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
    
    var coordinator: AddedPageCoordinator?
    var usecase: AddedPageUC
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv: PublishSubject<Any?> = PublishSubject()
    
    let disposeBag = DisposeBag()
    
    init(coordinator: AddedPageCoordinator, usecase: AddedPageUC){
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.setUpGift()
    }
    
    func transformToOutput(input: Input) -> Output {
        
        input.closeBtnTap
            .bind {
                print("AddPage VM --> SearchResult VM deliver gift")
                self.giftDeliverObv.onNext("AddPage 종료")
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output()
    }
    
    func setUpGift(){
        
        self.receiveGiftOvb
            .subscribe {[weak self] value in
                print("AddedPage received gift🎁 \(value)")
            }.disposed(by: self.disposeBag)

        self.giftDeliverObv
            .subscribe {[weak self] value in
                print("AddedPage deliverGift🎁 \(value)")
                self?.coordinator?.deliverGift(value: value)
            }.disposed(by: self.disposeBag)
    }
}
