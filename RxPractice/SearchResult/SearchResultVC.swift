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
    
    func setUp(){
        self.view.addSubview(self._view)
        self._view.drawView(frame: self.view.frame)
        
        self._viewModel.close(value: "닫기")
    }
    
    func bind(){
        let output = self._viewModel.transformToOutput(input: SearchResultVM.Input(closeBtnTap: self._view.rx.closeBtnTap), disposeBag: self.disposeBag)
        
//        output.imgUrlStr
//            .drive({ obv in
//                obv.
//            })
//            .drive(self._view.rx.imgUrlStr)
//            .disposed(by: self.disposeBag)
        
//            .map({ str in
//                guard let str = str else{
//                    return
//                }
//                let url = URL(string: str)
//                let data = try Data(contentsOf: url)
//
//                return UIImage(data: data)
//            })
            
    }
}
