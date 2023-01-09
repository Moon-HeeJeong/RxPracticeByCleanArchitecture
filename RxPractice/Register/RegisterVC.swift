//
//  ViewController.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/13.
//


import UIKit
import RxSwift
import RxCocoa

class RegisterVC: BaseViewController {
    deinit{
        print("deinit \(self)")
    }
    
    private let _viewModel: RegisterVM!
    private let _view: RegisterV!
    
    init(viewModel: RegisterVM, baseView: RegisterV){
        self._viewModel = viewModel
        self._view = baseView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setUp()
        self.bind()
    }
    
    override func setUp(){
        self.view.addSubview(self._view)
        self._view.drawView(frame: self.view.frame)
    }
    
    override func bind(){
        
        let txtCountCheckOutput = self._viewModel.transformToOutput(input: RegisterVM.Input(nameText: self._view.rx.nameText, pwText: self._view.rx.pwText, btnTap: self._view.rx.registerBtnTap), disposeBag: self.disposeBag)
        
        txtCountCheckOutput.isEnabledRegisterBtn
            .drive(self._view.rx.isEnabledRegisterBtn)
            .disposed(by: self.disposeBag)
        
        txtCountCheckOutput.searchedCount
            .map({ value in
                guard let v = value else{
                    return ""
                }
                return "result \(v)"
            })
            .drive(self._view.rx.countLabelTxt)
            .disposed(by: self.disposeBag)
        
        txtCountCheckOutput.isActiveAnimation
            .drive(self.isSpinnerOn)
            .disposed(by: self.disposeBag)
        
        txtCountCheckOutput.showAlert
            .drive { alertData in
                self.alertOvb.accept(alertData)
            }
            .disposed(by: self.disposeBag)
        
    }
    
    override func receiveGift(value: Any?) {
        self._viewModel.receiveGiftOvb.accept(value)
    }
    
    
//    func setTextField(){
//
//        let nameObservable = self._view.nameTextField.rx.text.map{$0?.count ?? 0}
//        nameObservable
//            .bind(with: self._view.nameWarnningLabel, onNext: { label, count in
//            label.isHidden = count > 5 ? false : true
//        })
//            .disposed(by: disposeBag)
//
//
//        let pwObservable = self._view.passwordTextField.rx.text.map{$0?.count ?? 0}
//        pwObservable
//            .bind(with: self._view.passwordWarnningLabel, onNext: { label, count in
//            label.isHidden = count > 5 ? false : true
//        })
//            .disposed(by: disposeBag)
//
//        let isSelectedObservable = self._view.checkBtn.rx.tap.map({self._view.checkBtn.isSelected})
//        let checkBtnObservable = self._view.checkBtn.rx.tap
//        self._view.checkBtn.rx.tap
//            .bind { _ in
//                self._view.checkBtn.isSelected = !self._view.checkBtn.isSelected
//                self._view.checkBtn.backgroundColor = self._view.checkBtn.isSelected ? .black : .lightGray
//        }
//            .disposed(by: disposeBag)
//
//
//        Observable.combineLatest(nameObservable, pwObservable, isSelectedObservable){ nameCount, pwCount, isSelected in
//                if isSelected{
//                    if nameCount > 5 || pwCount > 5{
//                        print("글자수 초과")
//                        return false
//                    }else if nameCount < 2 || pwCount < 2{
//                        print("글자수 너무 적음")
//                        return false
//                    }else{
//                        print("글자수 통과")
//                        return true
//                    }
//                }else{
//                    return false
//                }
//            }
//        .bind(to: self._view.confirmBtn.rx.isSelected)
//        .disposed(by: disposeBag)
//    }
}


//self.passwordTextField.rx
//    .controlEvent([.editingDidBegin])
//    .bind {
//
//                self.passwordTextField.backgroundColor = .cyan
//    }.disposed(by: disposeBag)
//
//self.passwordTextField.rx.controlEvent([.editingDidEnd])
//    .bind {
//                self.passwordTextField.backgroundColor = .yellow
//    }.disposed(by: disposeBag)



//        let isSelectRelay = PublishRelay<Bool>()
//            isSelectRelay.accept(self.checkBtn.isSelected)
