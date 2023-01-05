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
        var closeBtnTap: Observable<Void>
    }
    
    struct Output: OutputType{
//        var imgUrlStr: Driver<UIImage>
    }
    
    private var coordinator: SearchResultCoordinator?
    
    let giftObv: BehaviorRelay<String> = BehaviorRelay(value: "")
    var giftDeliverObv: Observable<String>{
        return self.giftObv.asObservable()
    }
    
    var getImgUrlStrObv: BehaviorRelay<String> = BehaviorRelay(value: "")
//    lazy var getImageObv: Observable<UIImage?> = {
//
//        return Observable.create(<#T##subscribe: (AnyObserver<_>) -> Disposable##(AnyObserver<_>) -> Disposable#>)
//
//
//
//            let url = URL(string: self.getImgUrlStrObv.value)!
//            let data = (try? Data(contentsOf: url))!
//        return UIImage(data: data)!
//    }()
//    var giftDeliverObv: Observable<String>{
//        return self.giftObv.asObservable()
//    }
    
    let usecase: SearchResultUC
    init(coordinator: SearchResultCoordinator, usecase: SearchResultUC, resultData: String?){
        self.coordinator = coordinator
        self.usecase = usecase
        
        print("search result receive \(resultData)")
    }
    
    func transformToOutput(input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.closeBtnTap
            .bind {
                self.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        return Output()
//        return Output(imgUrlStr: self.getImageObv.asDriver(onErrorJustReturn: nil))
    }
    
    func close(value: String){
        self.giftObv.accept(value)
    }
    
    
    
    func setupGift(){
        self.giftDeliverObv.subscribe { [weak self] str in
            self?.coordinator?.previousCoordinator?.vc?.receiveGift(value: str)
        }onCompleted: {
        }onDisposed: {
            Disposables.create {
                
            }
        }
    }
}
