//
//  AddedPageVC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/05.
//

import Foundation
import RxSwift
import RxCocoa

class AddedPageVC: BaseViewController{
    
    deinit{
        print("deinit \(self)")
    }
    
    private let _viewModel: AddedPageVM!
    private let _view: AddedPageV!
    
    
    init(viewModel: AddedPageVM, baseView: AddedPageV){
        self._viewModel = viewModel
        self._view = baseView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUp()
        self.bind()
    }
    
    override func setUp(){
        self.view.addSubview(self._view)
        self._view.drawView(frame: self.view.frame)
        
    }
    
    override func bind(){
        let output = self._viewModel.transformToOutput(input: AddedPageVM.Input(closeBtnTap: self._view.rx.closeBtnTap))
    }
    
    
    
    override func receiveGift(value: Any?) {
        self._viewModel.receiveGiftOvb.accept(value)
    }
}
