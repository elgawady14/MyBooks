//
//  HomeItemCell.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class HomeItemCell: UICollectionViewCell {

    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteIcon: UIImageView!
    var delegate: HomeController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        
        guard sender.tag < delegate.books.count else {
            return
        }
        let book = delegate.books[sender.tag];
        delegate.showTwoActionsAlert(title: "💡", msg: "Do you want to delete `\(book.title ?? "")` book?", btn1Title: "Yes", btn2Title: "No") {
            self.deleteBook(book.isbn)
        }
    }
    
    func deleteBook(_ isbn: String?) {
        
        guard let isbn = isbn else { return }
        do {
            try self.delegate.databaseHandler.deleteBookForCurrentUser(isbn)
            
            do {
                self.delegate.books = try self.delegate.databaseHandler.retrieveBooksForCurrentUser()
                self.delegate.collectionView.reloadData()
            } catch let error as NSError {
                self.delegate.showMessage(title: "⚠️", msg: error.localizedDescription)
            }
    
        } catch let error as NSError {
            self.delegate.showMessage(title: "⚠️", msg: error.localizedDescription)
        }
    }
}

extension HomeItemCell {
    
    func configure(_ index: Int, delegate: HomeController) {
        
        let book = delegate.books[index]
        self.delegate = delegate
        if let data = book.cover, let img = UIImage(data: data) {
            coverImgView.image = img
        } else {
            coverImgView.image = UIImage(named: "placeholder")
        }
        titleLbl.text = book.title ?? "No name"
        deleteBtn.isEnabled = delegate.editMode == .active
        deleteIcon.isHidden = delegate.editMode == .idle
        deleteBtn.tag = index
    }
    
    struct itemSize {
        static let width  = CGFloat(100.0)
        static let height = CGFloat(160.0)
    }
}


