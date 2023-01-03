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
    associatedtype Input: InputType
    associatedtype Output: OutputType
    
    func transformToOutput(input: Input, disposeBag: DisposeBag) -> Output
}

class RegisterVM: ViewModelType{
   
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
    
    var isLimitedNameCountOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isLimitedPwCountOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSameKeywordOvb: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var nameKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var pwKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchKeywordOvb: BehaviorRelay<String> = BehaviorRelay(value: "")
    var getCountOvb: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var isActivityOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showAlertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    
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
    
    let usecase: RegisterUC
    init(usecase: RegisterUC){
        self.usecase = usecase
    }
    
    func transformToOutput(input: Input, disposeBag: DisposeBag) -> Output {
//        input.nameText
//            .map({$0.count > 5 || $0.count < 2})
//            .bind(to: self.isLimitedNameCountOvb)
//            .disposed(by: disposeBag)
//
//        input.pwText
//            .map({$0.count > 5 || $0.count < 2})
//            .bind(to: self.isLimitedPwCountOvb)
//            .disposed(by: disposeBag)
        
        input.nameText
//            .filter({$0.count < 5 || $0.count > 2})
            .bind(to: self.nameKeywordOvb)
            .disposed(by: disposeBag)
        
        input.pwText
//            .filter({$0.count < 5 || $0.count > 2})
            .bind(to: self.pwKeywordOvb)
            .disposed(by: disposeBag)
        
        input.btnTap
            .bind {
                self.isActivityOn.accept(true)
                var count: Int?
                self.usecase.getData(keyword: self.nameKeywordOvb.value).subscribe { event in
                    
                    switch event{
                    case .next(let data):
                        print("getData next :: \(data.resultCount)")
                        self.getCountOvb.accept(data.resultCount)
                        count = data.resultCount
                        break
                    case .error(let err):
                        print("getData error :: \(err.localizedDescription)")
                        break
                    case .completed:
                        print("getData completed")
                        self.isActivityOn.accept(false)
                        if let count = count{
//                            self.showAlertOvb.accept(AlertData(title: "어얼러엇", message: "\(count)", btnType: .two(btnTxts: ["1번", "2번"], action2: { _ in
//                                print("2번")
//                            } )))
//                            self.showAlertOvb.accept(AlertData(title: "어얼러엇", message: "\(count)", btnType: .three(btnTxts: ["1","2","3"],action2: { _ in
//                                print("2번")
//                            }, action3: { _ in
//                                print("3번")
//                            })))
                            
                            self.showAlertOvb.accept(AlertData(title: "검색완료", message: "\(count)개의 검색결과가 있습니다.", btnType: .two(btnTxts: ["결과확인", "취소"], action1: { _ in
                                print("결과확인")
                            }, action2: { _ in
                                print("취소")
                            })))
                        }
                        
                        break
                    }
                }.disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(isEnabledRegisterBtn: self.isEnabledRegisterOvb.asDriver(onErrorJustReturn: false), searchedCount: self.getCountOvb.asDriver(onErrorJustReturn: -1), isActiveAnimation: self.isActivityOn.asDriver(), showAlert: self.showAlertOvb.asDriver())
    }
}
