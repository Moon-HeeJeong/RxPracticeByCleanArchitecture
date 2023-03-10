//
//  RegisterCoordinator.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/02.
//

import Foundation
import UIKit

class RegisterCoordinator: Coordinator{
    
//    weak var vc: RegisterVC?
    
    private var window: UIWindow
    
    init(window: UIWindow){
        self.window = window
        super.init()
    }
    
    override func start() {
        let mainVC = RegisterVC(viewModel: RegisterVM(coordinator: self, usecase: RegisterUC(repository: RegisterRP())), baseView: RegisterV())
        self.window.rootViewController = mainVC
        self.window.makeKeyAndVisible()
        self.vc = mainVC
    }
}

protocol RegisterSceneDirector: AnyObject{
    func goRegister()
}

extension RegisterCoordinator: SearchResultSceneDirector{
    func goSearchResult(resultData: String) {
        let coordi = SearchResultCoordinator(presenter: self.vc!, resultData: resultData)
        coordi.previousCoordinator = self
        coordi.start()
        self.children.append(coordi)
    }
}
