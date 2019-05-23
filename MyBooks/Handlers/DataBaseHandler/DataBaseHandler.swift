//
//  DataBaseHandler.swift
//  DeMo
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 1/23/18.
//  Copyright © 2018 Ahmad Abdul-Jawad Mahmoud. All rights reserved.
//

import CoreData

enum MyBooksError: Error {
    
    case registeredUser
    case unRegisteredUser
    case registeredBook
    case unRegisteredBook
}

extension MyBooksError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .registeredUser:
            return "Email already used with another user!"
        case .registeredBook:
            return "ISBN already used with another book!"
        case .unRegisteredUser:
            return "No user loggedin!"
        case .unRegisteredBook:
            return "ISBN not registered!"
        }
    }
}

class DataBaseHandler: NSObject {
    
    static let shared = DataBaseHandler()
    fileprivate var managedContext: NSManagedObjectContext!

    override init() {
        super.init()
    }

    func setManagedContext(appDelegate: AppDelegate) {
        managedContext = appDelegate.persistentContainer.viewContext
    }
}

extension DataBaseHandler {
    
    // MARK:- User
    
    func getCurrentUser() -> User? {
        guard let email = UserDefaultsHandler.shared.getUserEmail() else {
            return nil
        }
        return retrieveUser(email)
    }
    
    func retrieveUser(_ email: String) -> User? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.User)
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        guard let result = try? managedContext.fetch(fetchRequest) else { return nil }
        
        guard let user = result.first as? User else { return nil }
        return user
    }
    
    func insertNewUser(email: String, password: String) throws {
        
        guard retrieveUser(email) == nil else {
            throw MyBooksError.registeredUser
        }
        
        let entity = NSEntityDescription.entity(forEntityName: Constants.DBKeys.User, in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(email, forKeyPath: Constants.DBKeys.email)
        user.setValue(password, forKeyPath: Constants.DBKeys.password)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
}

extension DataBaseHandler {
    
    // MARK:- Book
    
    func retrieveBooksForCurrentUser() -> [Book] {
        
        guard let email = UserDefaultsHandler.shared.getUserEmail() else {
            return []
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.User)
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        guard let user = try? managedContext.fetch(fetchRequest).first as? User, let booksList = user.books else { return [] }
        
        guard let books = Array(booksList) as? [Book] else { return [] }
        return books
    }
    
    func insertNewBookForCurrentUser(isbn: String, title: String, cover: Data, releaseDate: Date, releaseNotify: Bool) throws -> Book {
        
        guard let user = getCurrentUser() else { throw MyBooksError.unRegisteredUser }
        
        guard retrieveBookForCurrentUser(isbn) == nil else {
            throw MyBooksError.registeredBook
        }
        let entity = NSEntityDescription.entity(forEntityName: Constants.DBKeys.Book, in: managedContext)!
        let book = NSManagedObject(entity: entity, insertInto: managedContext)
        book.setValue(isbn, forKeyPath: Constants.DBKeys.isbn)
        book.setValue(title, forKeyPath: Constants.DBKeys.title)
        book.setValue(cover, forKeyPath: Constants.DBKeys.cover)
        book.setValue(releaseDate, forKeyPath: Constants.DBKeys.releaseDate)
        book.setValue(releaseNotify, forKeyPath: Constants.DBKeys.releaseNotify)
        book.setValue(user, forKeyPath: Constants.DBKeys.user)
        var books = NSMutableSet()
        if let userBooks = user.books as? NSMutableSet {
            books = userBooks
        }
        books.add(book)
        user.setValue(books, forKey: Constants.DBKeys.books)

        do {
            try managedContext.save()
            return book as! Book
        } catch let error {
            print("Could not save. \(error)")
            throw error
        }
    }
    
    func retrieveBookForCurrentUser(_ isbn: String) -> Book? {
        
        guard let user = getCurrentUser(), let booksSet = user.books, let books = Array(booksSet) as? [Book] else { return nil }
        
        for book in books {
            if book.isbn == isbn {
                return book
            }
        }
        return nil
    }
    
    func updateBooksForCurrentUser(_ books: [Book]) throws {
        
        guard let user = getCurrentUser() else {
            return
        }
        user.setValue(NSSet(array: books), forKey: Constants.DBKeys.books)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func updateBookForCurrentUser(oldISBN: String,newISBN: String, title: String, cover: Data, releaseDate: Date, releaseNotify: Bool) throws -> Book {
        
        guard let book = retrieveBookForCurrentUser(oldISBN) else { throw MyBooksError.unRegisteredBook }
        
        book.setValue(newISBN, forKeyPath: Constants.DBKeys.isbn)
        book.setValue(title, forKeyPath: Constants.DBKeys.title)
        book.setValue(cover, forKeyPath: Constants.DBKeys.cover)
        book.setValue(releaseDate, forKeyPath: Constants.DBKeys.releaseDate)
        book.setValue(releaseNotify, forKeyPath: Constants.DBKeys.releaseNotify)
        
        do {
            try managedContext.save()
            return book
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func deleteBookForCurrentUser(_ isbn: String) throws {
        
        guard let user = getCurrentUser(), let booksSet = user.books, var books = Array(booksSet) as? [Book] else { return }
        
        var index = 0
        for book in books {
            if book.isbn == isbn {
                books.remove(at: index)
                break
            }
            index += 1
        }
        user.setValue(NSSet(array: books), forKey: Constants.DBKeys.books)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
        }
    }
}
