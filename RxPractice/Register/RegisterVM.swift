//
//  RegisterVM.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputType{}
protocol OutputType{}


protocol ViewModelType{
    associatedtype UseCase: UseCaseType
    associatedtype Coordinator: CoordinatorType
    associatedtype Input: InputType
    associatedtype Output: OutputType
    
    var isActivityOn: BehaviorRelay<Bool> {get set}
    var showAlertOvb: BehaviorRelay<AlertData?> {get set}
    
    var receiveGiftOvb: BehaviorRelay<Any?> {get set}
    var giftDeliverObv: PublishSubject<Any?> {get set}
    
    var coordinator: Coordinator?{get set}
    var usecase: UseCase{get set}
    
    func transformToOutput(input: Input) -> Output
}

extension ViewModelType{
    
//    func setUpGift(disposeBag: DisposeBag){
//        self.receiveGiftOvb
//            .subscribe {[weak self] value in
//                print("received gift🎁 \(value)")
//            }.disposed(by: disposeBag)
//
//        self.giftDeliverObv
//            .subscribe {[weak self] value in
//                print("deliverGift🎁 \(value)")
//                self?.coordinator?.deliverGift(value: value)
//            }.disposed(by: disposeBag)
//    }
}

class RegisterVM: ViewModelType{
    
    deinit{
        print("deinit \(self)")
    }
    
    struct Input: InputType{
        var nameText: Observable<String>
        var pwText: Observable<String>
        var btnTap: Observable<Void>
    }
    
    struct Output: OutputType{
        var isEnabledRegisterBtn: Driver<Bool>
        var searchedCount: Driver<Int?>
        var isActiveAnimation: Driver<Bool>
        var showAlert: Driver<AlertData?>
    }
    
    //protocol ==
    var coordinator: RegisterCoordinator?
    var usecase: RegisterUC
    
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    var receiveGiftOvb: BehaviorRelay<Any?> = BehaviorRelay(value: nil)
    var giftDeliverObv = PublishSubject<Any?>()
    //==========
    
    var isLimitedNameCountOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isLimitedPwCountOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSameKeywordOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var nameKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var pwKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var getCountOvb: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var imgUrlStrOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
   
    lazy var isEnabledRegisterOvb: Observable<Bool> = {
        Observable.combineLatest(self.nameKeywordOvb, self.pwKeywordOvb){name, pw in
            if name.count > 5 || name.count < 2 || pw.count > 5 || pw.count < 2{
                return false
            }else{
                if name == pw{
                    return true
                }else{
                    return false
                }
            }
        }
    }()
    
    let disposeBag = DisposeBag()
    
    init(coordinator: RegisterCoordinator, usecase: RegisterUC){
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.setUpGift()
    }
    
    func transformToOutput(input: Input) -> Output {
        
        input.nameText
            .bind(to: self.nameKeywordOvb)
            .disposed(by: disposeBag)
        
        input.pwText
            .bind(to: self.pwKeywordOvb)
            .disposed(by: disposeBag)
        
        input.btnTap
            .bind {
                self.isActivityOn.accept(true)
                var count: Int?
                self.usecase.getData(keyword: self.nameKeywordOvb.value).subscribe { event in

                    switch event{
                    case .next(let data):
                        self.getCountOvb.accept(data.resultCount)
                        print("url::\(data.results?.first?.ipadScreenshotUrls.first ?? "")")
                        self.imgUrlStrOvb.accept(data.results?.first?.ipadScreenshotUrls.first ?? "")
                        count = data.resultCount
                        break
                    case .error(let err):
                        print("getData error :: \(err.localizedDescription)")
                        break
                    case .completed:
                        self.isActivityOn.accept(false)
                        if let count = count{
                            self.showAlertOvb.accept(AlertData(title: "검색완료", message: "\(count)개의 검색결과가 있습니다.", btnType: .two(btnTxts: ["결과확인", "취소"], action1: { [weak self] _ in
                                print("결과확인")
                                self?.coordinator?.goSearchResult(resultData: self?.imgUrlStrOvb.value ?? "")
                            }, action2: {[weak self] _ in
                                print("취소")
                            })))
                        }
                        break
                    }
                }.disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        return Output(isEnabledRegisterBtn: self.isEnabledRegisterOvb.asDriver(onErrorJustReturn: false), searchedCount: self.getCountOvb.asDriver(onErrorJustReturn: -1), isActiveAnimation: self.isActivityOn.asDriver(), showAlert: self.showAlertOvb.asDriver())
    }
    
    func setUpGift(){
        
        self.receiveGiftOvb
            .subscribe {[weak self] value in
                print("Register received gift🎁 \(value)")
            }.disposed(by: self.disposeBag)

        self.giftDeliverObv
            .subscribe {[weak self] value in
                print("Register deliverGift🎁 \(value)")
                self?.coordinator?.deliverGift(value: value)
            }.disposed(by: self.disposeBag)
    }
}
