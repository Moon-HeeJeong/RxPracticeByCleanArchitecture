//
//  SearchResultVM.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultVM: ViewModelType{
    
    deinit{
        print("deinit \(self)")
    }
    
    struct Input: InputType{
        var nextBtnTap: Observable<Void>
        var closeBtnTap: Observable<Void>
    }
    
    struct Output: OutputType{
        var img: Driver<UIImage?>
    }
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv = PublishSubject<Any?>()
    
    var getImgUrlStrObv: BehaviorRelay<String> = BehaviorRelay(value: "")
    var getImgObv: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    weak var coordinator: SearchResultCoordinator?
    var usecase: SearchResultUC
    
    let disposeBag = DisposeBag()
    
    init(coordinator: SearchResultCoordinator, usecase: SearchResultUC){
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.setUpGift()
    }
    
    func transformToOutput(input: Input) -> Output {
        input.nextBtnTap
            .bind {
//                self.giftObv.accept("== SearchResultVM -> AddedPageVM 이동 중 ==")
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("== SearchResultVM -> AddedPageVM 이동 중 ==")
                self.coordinator?.goAddedPage()
            }.disposed(by: disposeBag)
        input.closeBtnTap
            .bind {
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("== SearchResultVM 화면 종료 중 ==")
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output(img: self.getImgObv.asDriver(onErrorJustReturn: nil))
    }
    
    
    func setUpGift(){
        
        self.receiveGiftOvb
            .subscribe {[weak self] value in
                print("received gift🎁 \(value)")
            }.disposed(by: self.disposeBag)

        self.giftDeliverObv
            .subscribe {[weak self] value in
                print("deliverGift🎁 \(value)")
                self?.coordinator?.deliverGift(value: value)
            }.disposed(by: self.disposeBag)
    }
}
