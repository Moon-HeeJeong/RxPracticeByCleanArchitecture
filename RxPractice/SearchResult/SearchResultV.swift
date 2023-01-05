//
//  SearchResultV.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchResultV: UIView{
    deinit{
        print("deinit \(self)")
    }
    
    var img: UIImageView!
    var closeBtn: UIButton!
    
    init(){
        super.init(frame: .zero)
//        self.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawView(frame: CGRect){
        self.frame = frame
        self.backgroundColor = .systemBlue
        
        self.img = {
            let img = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.size.width/2, height: self.frame.size.height/3)))
            img.center.x = self.frame.size.width/2
            img.center.y = self.frame.size.height/2
            img.backgroundColor = .yellow
            return img
        }()
        self.addSubview(self.img)
        
        let imgEndPosY = self.img.frame.origin.y + self.img.frame.size.height
        
        self.closeBtn = {
            let btnWidth = self.img.frame.size.width
            let btnHeight = CGFloat(40)
            let btn = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: imgEndPosY + CGFloat(20)), size: CGSize(width: btnWidth, height: btnHeight)))
            btn.center.x = self.frame.size.width/2
            btn.backgroundColor = .blue
            btn.setTitle("X", for: .normal)
            return btn
        }()
        self.addSubview(self.closeBtn)
    }
}

extension Reactive where Base: SearchResultV{
    
    var imgUrlStr: Binder<UIImage?>{
        self.base.img.rx.image
    }
    
    var closeBtnTap: Observable<Void>{
        self.base.closeBtn.rx.tap.asObservable()
    }
}
