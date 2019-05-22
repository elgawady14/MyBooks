//
//  HomeController+DB.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 22/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension HomeController {
    
    func addBooksForUser(_ email: String) {
        
        //guard databaseHandler.retrieveBook(isbn) == nil else { return }
        let imgs = ["img1", "img2", "img3", "img4", "img5", "img6", "img7"]
        var books = [Book]()
        for str in imgs {
            if let img = UIImage(named: str), let data = img.pngData(), let book = createBook(isbn: str, title: str, cover: data, releaseDate: Date(), releaseNotify: true) {
                books.append(book)
            }
        }
        guard !books.isEmpty else {
            return
        }
        do {
            try databaseHandler.updateBooksForCurrentUser(books)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func createBook(isbn: String, title: String, cover: Data, releaseDate: Date, releaseNotify: Bool) -> Book? {
        
        // make sure that this book is not stored before.
        let book = databaseHandler.retrieveBookForCurrentUser(isbn)
        guard book == nil else {
            return book
        }
        do {
            let book = try self.databaseHandler.insertNewBookForCurrentUser(isbn: isbn, title: title, cover: cover, releaseDate: releaseDate, releaseNotify: releaseNotify)
            return book
        } catch let error as NSError {
            print(error.description)
            return nil
        }
    }
}
