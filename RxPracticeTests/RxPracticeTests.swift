//
//  RxPracticeTests.swift
//  RxPracticeTests
//
//  Created by LittleFoxiOSDeveloper on 2022/12/13.
//

import XCTest
import RxSwift
import RxCocoa
import MHTools

final class RxPracticeTests: XCTestCase {
    
    var registerVM: RegisterVM!
    let dBag = DisposeBag()
    
    var api: APITest?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.registerVM = RegisterVM(usecase: RegisterUC(repository: RegisterRP()))
        self.api = APITest()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.registerVM = nil
        self.api = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testNameCountOver() throws{
//
//        let registerView = RegisterV()
//        registerView.drawView(frame: .zero)
//        let observable = registerView.rx.nameText
//        observable.on(.next("test test"))
//
//
//        observable.map({$0.count > 5})
//            .bind(to: self.registerVM.isOver)
//            .disposed(by: self.dBag)
//
//        XCTAssertTrue(self.registerVM.isOver.value)
//    }
    
    
//    func testTxtCountOverTwo() throws{
//
//        let nameOvb: Observable<String> = Observable<String>.create { ov in
//            ov.onNext("test")
//            return Disposables.create()
//        }
//
//        let pwOvb: Observable<String> = Observable<String>.create { ov in
//            ov.onNext("test")
//            return Disposables.create()
//        }
//
//
//        let out = self.registerVM.transformToOutput(input: RegisterVM.Input(nameText: nameOvb, pwText: pwOvb), disposeBag: self.dBag)
//
//        out.isEnabledRegisterBtn
//            .drive(onNext: { value in
//                XCTAssertTrue(value)
//            }).disposed(by: self.dBag)
//    }
    
    func testMHAPI() throws{
        let exception = self.expectation(description: "test api by rx call")
        
        self.api?.callByRx(TestAPI(keyword: "kb", config: APIConfig()))
            .subscribe(
               
                onNext: { element in
                    print("res ::\(element)")
                    
                    exception.fulfill()
                    XCTAssertNotNil(element)
                }, onError: { error in
                    print("error ::\((error).localizedDescription)")
                    exception.fulfill()
                    XCTAssertNil(error, "on error")
                }, onCompleted: {
                    print("completed")
            }, onDisposed: {
                print("disposed")
            }
            ).disposed(by: self.dBag)
        wait(for: [exception], timeout: 4)
    }
    
    func testGetResultCount() throws{
        let exception = self.expectation(description: "test api by repository call")
        let out = self.registerVM.usecase.repository.callAPI(keyword: "kb")
        out.subscribe(
            onNext: { value in
                print("next : ", value)
                exception.fulfill()
                XCTAssertNotNil(value)
            },
            onError: { err in
                print("error : ", err)
            }, onCompleted: {
                print("completed")
            }).disposed(by: self.dBag)
        wait(for: [exception], timeout: 4)
    }
    
    
}

