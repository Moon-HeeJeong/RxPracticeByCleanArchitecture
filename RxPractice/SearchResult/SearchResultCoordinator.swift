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
        let vc = SearchResultVC(viewModel: SearchResultVM(coordinator: self, usecase: SearchResultUC(repository: SearchResultRP())), baseView: SearchResultV())
        
        let naviVC = UINavigationController(rootViewController: vc)
        naviVC.modalPresentationStyle = .fullScreen
        self.presenter?.present(naviVC, animated: true)
        self.navigationController = naviVC
        self.vc = vc
        vc.initValues(resultData: self.resultData)
    }
}
protocol SearchResultSceneDirector: AnyObject{
    func goSearchResult(resultData: String)
}
extension SearchResultCoordinator: AddedPageSceneDirector{
    func goAddedPage() {
        let coordi = AddedPageCoordinator(navigationController: self.navigationController!)
        coordi.previousCoordinator = self
        coordi.start()
        self.children.append(coordi)
    }
}
