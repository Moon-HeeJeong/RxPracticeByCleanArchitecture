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
    
    private weak var coordinator: SearchResultCoordinator?
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv = PublishSubject<Any?>()
    
    var getImgUrlStrObv: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    lazy var getImgObv:Observable<UIImage?> = {
        Observable.just(self.resultData ?? "")
//            .flatMap({ str -> Observable<UIImage?> in
//                if let url = URL(string: str){
//                    let data = try? Data(contentsOf: url)
//                    return UIImage(data: data)
//                }
//            })
            .map({URL(string: $0)!})
            .map({(try? Data(contentsOf: $0))!})
            .map({UIImage(data: $0)!})
//            .filter({$0 != nil})
    }()
    
    let usecase: SearchResultUC
    
    var resultData: String?
    
    init(coordinator: SearchResultCoordinator, usecase: SearchResultUC, resultData: String?){
        self.coordinator = coordinator
        self.usecase = usecase
        self.resultData = resultData
        
        print("search result receive \(resultData)")
        
        self.setUpGift(coordinator: coordinator)
//        self.setUpGift()
    }
    
    func transformToOutput(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.nextBtnTap
            .bind {
//                self.giftObv.accept("== SearchResultVM -> AddedPageVM 이동 중 ==")
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("==>>>>>")
//                self.giftDeliverObv.onNext("== SearchResultVM -> AddedPageVM 이동 중 ==")
                self.coordinator?.goAddedPage()
            }.disposed(by: disposeBag)
        input.closeBtnTap
            .bind {
//                self.giftObv.accept("== SearchResultVM 화면 종료 중 ==")
                print("SearchResult VM --> Registe VM deliver gift")
                self.giftDeliverObv.onNext("== SearchResultVM 화면 종료 중 ==")
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output(img: self.getImgObv.asDriver(onErrorJustReturn: nil))
    }
    
}
