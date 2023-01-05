//
//  SearchResultCoordinator.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/02.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SearchResultCoordinator: Coordinator{
    
    private let resultData: String?
    
    init(presenter: UIViewController, resultData: String?) {
        self.resultData = resultData
        super.init(presenter: presenter)
    }
    
    override func start() {
        let vc = SearchResultVC(viewModel: SearchResultVM(coordinator: self, usecase: SearchResultUC(repository: SearchResultRP()), resultData: self.resultData), baseView: SearchResultV())
        
        
        let naviVC = UINavigationController(rootViewController: vc)
        naviVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(vc, animated: true)
        self.presenter?.present(naviVC, animated: true)
        self.navigationController = naviVC
        
        self.vc = vc
    }
    
    
}
protocol SearchResultSceneDirector: AnyObject{
    func goSearchResult(resultData: String)
}
