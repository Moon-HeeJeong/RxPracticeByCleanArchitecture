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
    
//    private weak var coordinator: SearchResultCoordinator?
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv = PublishSubject<Any?>()
    
    var getImgUrlStrObv: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    var getImgObv: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
//    lazy var getImgObv:Observable<UIImage?> = { //얘로 바로 받기
//        Observable.just(self.resultData ?? "")
////            .flatMap({ str -> Observable<UIImage?> in
////                if let url = URL(string: str){
////                    let data = try? Data(contentsOf: url)
////                    return UIImage(data: data)
////                }
////            })
//            .map({URL(string: $0)!})
//            .map({(try? Data(contentsOf: $0))!})
//            .map({UIImage(data: $0)!})
////            .filter({$0 != nil})
//    }()
    
    
    weak var coordinator: SearchResultCoordinator?
    var usecase: SearchResultUC
    
    let dBag = DisposeBag()
    init(coordinator: SearchResultCoordinator, usecase: SearchResultUC){
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.setUpGift(disposeBag: dBag)
    }
    
    func transformToOutput(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.nextBtnTap
            .bind {
//                self.giftObv.accept("== SearchResultVM -> AddedPageVM 이동 중 ==")
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("== SearchResultVM -> AddedPageVM 이동 중 ==")
                (self.coordinator as? SearchResultCoordinator)?.goAddedPage()
            }.disposed(by: disposeBag)
        input.closeBtnTap
            .bind {
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("== SearchResultVM 화면 종료 중 ==")
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output(img: self.getImgObv.asDriver(onErrorJustReturn: nil))
    }
    
}
