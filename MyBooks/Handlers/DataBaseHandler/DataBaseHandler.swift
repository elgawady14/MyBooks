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
    case registeredBook
    case isbnNotFound
}

extension MyBooksError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .registeredUser:
            return NSLocalizedString("user_registered", comment: "")
        case .registeredBook:
            return NSLocalizedString("book_registered", comment: "")
        case .isbnNotFound:
            return NSLocalizedString("isbnNotFound", comment: "")

        }
    }
}

class DataBaseHandler: NSObject {
    
    static let shared = DataBaseHandler()
    fileprivate var managedContext: NSManagedObjectContext!
    
    override init() {
        super.init()
        managedContext = appDelegate.persistentContainer.viewContext
    }

}

extension DataBaseHandler {
    
    // MARK:- User
    func insertNewUser(email: String, password: String) throws {
        
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
    
    func isUserRegistered(_ email: String, _ password: String) -> User? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.User)
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        guard let result = try? managedContext.fetch(fetchRequest) else { return nil }
        
        guard let user = result.first as? User else { return nil }
        return user
    }
    
    // MARK:- Book
    func insertNewBook(isbn: String, title: String, releaseDate: Date, releaseNotify: Bool) throws {
        
        let entity = NSEntityDescription.entity(forEntityName: Constants.DBKeys.Book, in: managedContext)!
        let book = NSManagedObject(entity: entity, insertInto: managedContext)
        book.setValue(isbn, forKeyPath: Constants.DBKeys.isbn)
        book.setValue(title, forKeyPath: Constants.DBKeys.title)
        book.setValue(releaseDate, forKeyPath: Constants.DBKeys.releaseDate)
        book.setValue(releaseNotify, forKeyPath: Constants.DBKeys.releaseNotify)

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func retrieveBook(_ isbn: String) -> Book? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.Book)
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        guard let result = try? managedContext.fetch(fetchRequest) else { return nil }
        
        guard let book = result.first as? Book else { return nil }
        return book
    }
    
    func retrieveBooksForUser(_ email: String) -> [Book]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.User)
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        guard let user = try? managedContext.fetch(fetchRequest).first as? User, let booksList = user.books else { return nil }
        
        guard let books = Array(booksList) as? [Book] else { return nil }
        return books
    }
    
    func deleteBook(_ isbn: String) throws {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.DBKeys.Book)
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            guard let result = try managedContext.fetch(fetchRequest).first else {
                throw MyBooksError.isbnNotFound
            }
            managedContext.delete(result)
        } catch let error as NSError {
            throw error
        }
    }
    
    func updateBook(isbn: String, title: String, releaseDate: Date, releaseNotify: Bool) throws {
        
        guard let book = retrieveBook(isbn) else { throw MyBooksError.registeredBook }
    
        book.setValue(isbn, forKeyPath: Constants.DBKeys.isbn)
        book.setValue(title, forKeyPath: Constants.DBKeys.title)
        book.setValue(releaseDate, forKeyPath: Constants.DBKeys.releaseDate)
        book.setValue(releaseNotify, forKeyPath: Constants.DBKeys.releaseNotify)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
}
