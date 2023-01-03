//
//  RegisterCoordinator.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/02.
//

import Foundation

class RegisterCoordinator: Coordinator{
    
//    weak var vc: RegisterVC?
    
    override func start() {
        let vc = RegisterVC(viewModel: RegisterVM(usecase: RegisterUC(repository: RegisterRP())), baseView: RegisterV())
        self.navigationController?.pushViewController(vc, animated: true)
        self.vc = vc
    }
}

protocol RegisterSceneDirector: AnyObject{
    func goRegister()
}
