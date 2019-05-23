//
//  HomeController+BooksTracker.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 23/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

extension HomeController: BooksTracker {
    
    func AddController(didAddNewBook book: Book) {
        
        pop()
        checkoutReleaseNotifier(for: book)
        showMessage(title: "👍", msg: "`\(book.title!)` book has been added successfully!")
        fetchUserBooks()
        collectionView.reloadData()
    }
    
    func EditController(didUpdateBook book: Book) {
        
        pop()
        checkoutReleaseNotifier(for: book)
        showMessage(title: "👍", msg: "`\(book.title!)` book has been updated successfully!")
        fetchUserBooks()
        collectionView.reloadData()
    }
}

extension HomeController {
    
    func checkoutReleaseNotifier(for book: Book) {
        
        guard book.releaseNotify, book.releaseDate!.compare(Date()) == .orderedDescending else { return }
        scheduleLocalNotification(title: "📖", body: "hurray! `\(book.title!)` book has been released! 🎉", date: book.releaseDate!)
    }
}
