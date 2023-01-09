//
//  AddedPageV.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddedPageV: UIView{
    deinit{
        print("deinit \(self)")
    }
    
    var closeBtn: UIButton!
    
    init(){
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawView(frame: CGRect){
        self.frame = frame
        self.backgroundColor = .yellow
        
        self.closeBtn = {
            let btnWidth = self.frame.size.width/2
            let btnHeight = CGFloat(40)
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: btnWidth, height: btnHeight)))
            btn.center.x = self.frame.size.width/2
            btn.center.y = self.frame.size.height/2
            btn.backgroundColor = .blue
            btn.setTitle("X", for: .normal)
            return btn
        }()
        self.addSubview(self.closeBtn)
    }
}
extension Reactive where Base: AddedPageV{
    var closeBtnTap: Observable<Void>{
        self.base.closeBtn.rx.tap.asObservable()
    }
}
