//
//  SearchResultVC.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultVC: BaseViewController{
    deinit{
        print("deinit \(self)")
    }
    
    private let _viewModel: SearchResultVM!
    private let _view: SearchResultV!
    
    
    init(viewModel: SearchResultVM, baseView: SearchResultV){
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
        let output = self._viewModel.transformToOutput(input: SearchResultVM.Input( nextBtnTap: self._view.rx.nextBtnTap, closeBtnTap: self._view.rx.closeBtnTap), disposeBag: self.disposeBag)
        
        
        output.img
            .drive(self._view.rx.image)
            .disposed(by: self.disposeBag)
        
    }
    
    func initValues(resultData: String?){
        if let url = URL(string: resultData ?? ""){
            let data = (try? Data(contentsOf: url))!
            let img = UIImage(data: data)
            self._viewModel.getImgObv.accept(img)
        }
    }
    
    override func receiveGift(value: Any?) {
        self._viewModel.receiveGiftOvb.accept(value)
    }
}
