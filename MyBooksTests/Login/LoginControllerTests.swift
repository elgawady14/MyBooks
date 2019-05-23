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

    override func setUp() {}

    override func tearDown() {}

    func testLoginForUnregisteredUser() {
        
        let testExpectation = expectation(description: "LoginFailureForUnregisteredUser")
        do {
            
            let user = try databaseHandler.login(email: TestConstants.email, password: TestConstants.password)
            XCTFail("Login had to fail for user with email: \(user.email!)")
        } catch let error as NSError {
            print(error.localizedDescription)
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: TestConstants.timeoutInterval)
    }
}
