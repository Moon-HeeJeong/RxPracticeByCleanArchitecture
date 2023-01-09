//
//  Coordinator.swift
//  RxPractice
//
//  Created by LittleFoxiOSDeveloper on 2023/01/02.
//

import Foundation
import UIKit


class Coordinator : NSObject{
    
    deinit{
        print("deinit \(self)")
    }
    
    var children: [Coordinator] = []
    weak var previousCoordinator: Coordinator?
    weak var vc: BaseViewController?
    
    unowned let presenter: UIViewController?
    unowned var navigationController: UINavigationController?
    
    override init(){
        self.presenter = nil
        self.navigationController = nil
    }
    
    init(presenter: UIViewController){
        self.presenter = presenter
        self.navigationController = nil
    }
    
    init(navigationController: UINavigationController){
        self.presenter = nil
        self.navigationController = navigationController
    }
    
    func start(){
        
    }
    
    func finish(){
        if let navi = self.navigationController{
            if navi.children.count >= 2{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.dismiss(animated: true)
            }
        }else{
//            self.presenter?.dismiss(animated: true) //이건 이전화면을 지우는거 아닌가...
            self.vc?.dismiss(animated: true)
        }
        
        //dealoc
        self.previousCoordinator?.childDidFinish(self)
        
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in self.children.enumerated(){
            if coordinator === child{
                self.children.remove(at: index)
                break
            }
        }
    }
    
    func deliverGift(value: Any?){
        self.previousCoordinator?.vc?.receiveGift(value: value)
    }
}
