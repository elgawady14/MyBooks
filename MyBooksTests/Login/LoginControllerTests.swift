//
//  LoginTests.swift
//  MyBooksTests
//
//  Created by Ahmad Abduljawad on 23/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import XCTest
@testable import MyBooks

class LoginControllerTests: XCTestCase {

    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginFailureForUnregisteredUser() {
        
        let testExpectation = expectation(description: "LoginFailureForUnregisteredUser")
        do {
            
            let user = try databaseHandler.login(email: TestConstants.email, password: TestConstants.password)
            XCTFail("Login had to failed for user with email: \(user.email!)")
        } catch let error as NSError {
            print(error.localizedDescription)
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: TestConstants.timeoutInterval)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
