//
//  LoginTests.swift
//  MyBooksTests
//
//  Created by Ahmad Abduljawad on 23/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import XCTest
@testable import MyBooks

class AddEditControllerTests: XCTestCase {
    
    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared
    
    override func setUp() {}
    
    override func tearDown() {
        userDefaultsHandler.setUserEmail(nil)
    }
    
    func testUpdateBookDataForUnregisteredBook() {
        
        let testExpectation = expectation(description: "UpdateBookDataForUnregisteredBook")
        do {
            
            userDefaultsHandler.setUserEmail(TestConstants.email)
            let coverImage = UIImage(named: TestConstants.coverImage, in: Bundle.main, compatibleWith: nil)!.pngData()!

            let _ = try databaseHandler.updateBookForCurrentUser(oldISBN: TestConstants.isbn, newISBN: TestConstants.isbn, title: TestConstants.title, cover: coverImage, releaseDate: Date(), releaseNotify: true)
            XCTFail("Update book had to fail for the unregistered book with ISBN: \(TestConstants.isbn)")
        } catch let error as NSError {
            print(error.localizedDescription)
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: TestConstants.timeoutInterval)
    }
}


