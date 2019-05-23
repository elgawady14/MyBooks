//
//  HomeControllerTests.swift
//  MyBooksTests
//
//  Created by Ahmad Abduljawad on 23/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import XCTest
@testable import MyBooks

class HomeControllerTests: XCTestCase {
    
    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared
    
    override func setUp() {}
    
    override func tearDown() {
        userDefaultsHandler.setUserEmail(nil)
    }
    
    func testBooksRetrievalForUnregisteredUser() {
        
        let testExpectation = expectation(description: "BooksRetrievalFailureForUnregisteredUser")
        do {
            
            userDefaultsHandler.setUserEmail(TestConstants.email)
            let _ = try databaseHandler.retrieveBooksForCurrentUser()
            XCTFail("Books Retrieval had to fail for the unregistered user with email: \(userDefaultsHandler.getUserEmail()!)")
        } catch let error as NSError {
            print(error.localizedDescription)
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: TestConstants.timeoutInterval)
    }
    
}

