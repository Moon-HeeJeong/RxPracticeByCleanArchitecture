//
//  BaseViewController.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct AlertData{
    var title: String?
    var message: String
    var btnType: AlertBtnType
}

enum AlertBtnType{
    typealias Handler = ((UIAlertAction)->Void)?
    case one(btnTxt: String = "확인", action: Handler? = nil)
    case two(btnTxts: [String] = ["확인", "취소"], action1: Handler? = nil, action2: Handler)
    case three(btnTxts: [String] = ["확인", "취소", "나가기"], action1: Handler? = nil, action2: Handler, action3: Handler)
    
    var btnTxts: [String]{
        switch self {
        case .one(let btnTxt, _):
            return [btnTxt]
        case .two(let btnTxts, _, _):
            return btnTxts
        case .three(let btnTxts, _, _, _):
            return btnTxts
        }
    }
    
    var actions: [Handler]?{
        switch self {
        case .one(_, let action):
            if let action = action {
                return [action]
            }else{
                return nil
            }
        case .two(_, let action1, let action2):
            var actions: [Handler] = []
            if let action1 = action1{
                actions.append(action1)
            }else{
                actions.append(nil)
            }
            actions.append(action2)
            return actions
        case .three(_, let action1, let action2, let action3):
            var actions: [Handler] = []
            if let action1 = action1{
                actions.append(action1)
            }else{
                actions.append(nil)
            }
            actions.append(action2)
            actions.append(action3)
            return actions
        }
    }
}

class BaseViewController: UIViewController{
    
    var isSpinnerOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var alertOvb: BehaviorRelay<AlertData?> = BehaviorRelay(value: nil)
    
    var spinner: UIActivityIndicatorView?
    var alert: UIAlertController?
    var disposeBag = DisposeBag()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.setSpinner()
        self.setAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSpinner(){
        if #available(iOS 13.0, *) {
            self.spinner = UIActivityIndicatorView(style: .large)
            self.spinner?.color = .red
            self.spinner?.center = self.view.center
            self.view.addSubview(self.spinner!)
        } else {
        }
        
        self.isSpinnerOn.bind { isOn in
            print("spinner \(isOn)")
            if isOn{
                self.spinner?.startAnimating()
            }else{
                self.spinner?.stopAnimating()
            }
        }.disposed(by: self.disposeBag)
    }
    
    func setAlert(){
        self.alertOvb.bind { alertData in
            guard let alertData = alertData else{
                return
            }
            self.alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
            
            for i in 0..<alertData.btnType.btnTxts.count{
                let data = alertData.btnType
                let action = UIAlertAction(title: data.btnTxts[i], style: .default, handler: data.actions?[i] ?? {[weak self] action in
                    self?.hideAlert()
                })
                self.alert?.addAction(action)
            }
            
            self.present(self.alert!, animated: false)
        }.disposed(by: self.disposeBag)
    }
    
    func hideAlert(){
        self.alert?.dismiss(animated: false, completion: {
            self.alert = nil
        })
    }
}
