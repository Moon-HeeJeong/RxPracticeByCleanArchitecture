//
//  RegisterV.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2022/12/15.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RegisterV: UIView{
    deinit{
        print("deinit \(self)")
    }
    
    var nameTextField: UITextField!
    var passwordTextField: UITextField!
    var checkBtn: UIButton!
    var confirmBtn: UIButton!
    
    var nameWarnningLabel: UILabel!
    var passwordWarnningLabel: UILabel!
    
    var versionLabel: UILabel!
    
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawView(frame: CGRect){
        self.frame = frame
        let fieldWidth = frame.size.width/2
        let fieldHeight = (100/500)*fieldWidth
        
        self.nameTextField = {
            let field = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            field.center.x = frame.size.width/2
            field.center.y = frame.size.height/2 - fieldHeight*2
//            field.backgroundColor = .yellow
            field.borderStyle = .bezel
            field.textColor = .black
            field.placeholder = "닉네임"
//            field.text = "test word"
            return field
        }()
        self.addSubview(self.nameTextField)
        
        let nameEndPosY = self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height
        
        self.nameWarnningLabel = {
            let lb = UILabel()
            lb.textColor = .red
            lb.text = "닉네임 글자 수 지켜~"
            lb.font = UIFont.systemFont(ofSize: fieldHeight/4)
            lb.sizeToFit()
            lb.frame.origin.x = self.nameTextField.frame.origin.x
            lb.frame.origin.y = nameEndPosY
            lb.isHidden = true
            return lb
        }()
        self.addSubview(self.nameWarnningLabel)
        
        self.passwordTextField = {
            let field = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            field.center.x = frame.size.width/2
            field.frame.origin.y = nameEndPosY + fieldHeight
//            field.backgroundColor = .
            field.borderStyle = .bezel
            field.textColor = .black
            field.placeholder = "비밀번호"
            return field
        }()
        self.addSubview(self.passwordTextField)
        
        let pwEndPosY = self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height
        
        self.passwordWarnningLabel = {
            let lb = UILabel()
            lb.textColor = .red
            lb.text = "비밀번호 글자 수 지켜~"
            lb.font = UIFont.systemFont(ofSize: fieldHeight/4)
            lb.sizeToFit()
            lb.frame.origin.x = self.passwordTextField.frame.origin.x
            lb.frame.origin.y = pwEndPosY
            lb.isHidden = true
            return lb
        }()
        self.addSubview(self.passwordWarnningLabel)
        
        let btnHeight = fieldHeight/2
        let btnWidth = btnHeight
        self.checkBtn = {
            
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: self.passwordTextField.frame.origin.x, y: pwEndPosY + btnHeight), size: CGSize(width: btnWidth, height: btnHeight)))
            btn.backgroundColor = .lightGray
            return btn
        }()
        self.addSubview(self.checkBtn)
        
        let checkBtnLabel: UILabel = {
            let lb = UILabel()
            lb.text = "모두 동의합니다."
            lb.textColor = .black
            lb.font = UIFont.systemFont(ofSize: btnHeight*0.8)
            lb.sizeToFit()
            lb.frame.origin.x = self.checkBtn.frame.origin.x + btnWidth + btnWidth/2
            lb.center.y = self.checkBtn.center.y
            return lb
        }()
        self.addSubview(checkBtnLabel)
         
        self.confirmBtn = {
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fieldWidth, height: fieldHeight)))
            btn.backgroundColor = .lightGray
            btn.setTitle("Tap 불가~", for: .normal)
            btn.setTitle("Tap 가능~", for: .selected)
            btn.setTitleColor(.white, for: .normal)
            btn.setTitleColor(.black, for: .selected)
            btn.center.x = self.passwordTextField.center.x
            btn.frame.origin.y = pwEndPosY + fieldHeight*2
            return btn
        }()
        self.addSubview(self.confirmBtn)
        
        self.versionLabel = {
            let lb = UILabel()
            lb.text = "test Labelllllllllllllllllllllllll"
            lb.font = UIFont.boldSystemFont(ofSize: fieldHeight*0.8)
            lb.textColor = .black
            lb.frame.size.width = self.frame.size.width
            lb.sizeToFit()
            lb.textAlignment = .center
            lb.center.x = frame.size.width/2
            lb.frame.origin.y = self.nameTextField.frame.origin.y - fieldHeight - lb.frame.size.height
//            lb.isHidden = true
            return lb
        }()
        self.addSubview(self.versionLabel)
    }
}

extension Reactive where Base: RegisterV{
//    var nameText: ControlProperty<String>{
//        self.base.nameTextField.rx.text.orEmpty//.asObservable()
//    }

    var nameText: Observable<String>{
        self.base
            .nameTextField
            .rx
            .text
            .orEmpty
            .asObservable()
    }
    
    var pwText: Observable<String>{
        self.base
            .passwordTextField
            .rx
            .text
            .orEmpty
            .asObservable()
    }
    
    var isVersionHidden: Binder<Bool>{
        self.base.versionLabel.rx.isHidden
    }
    
    var isEnabledRegisterBtn: Binder<Bool>{
        self.base.confirmBtn.rx.isSelected
    }
    
    var countLabelTxt: Binder<String?>{
        self.base.versionLabel.rx.text
    }
    
    
    var registerBtnTap: Observable<Void>{
        self.base.confirmBtn.rx.tap.asObservable()
    }
    
}
