//
//  AddedPageCoordinator.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/05.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class AddedPageCoordinator: Coordinator{
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let vc = AddedPageVC(viewModel: AddedPageVM(coordinator: self, usecase: AddedPageUC(repository: AddedPageRP())), baseView: AddedPageV())
        self.navigationController?.pushViewController(vc, animated: true)
        self.vc = vc
    }
    
}
protocol AddedPageSceneDirector: AnyObject{
    func goAddedPage()
}
