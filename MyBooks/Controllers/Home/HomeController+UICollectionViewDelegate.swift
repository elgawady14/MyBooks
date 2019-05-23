//
//  HomeController+UICollectionViewDelegate.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension HomeController: UICollectionViewDelegate {
    
    // MARK:- DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let book = books[indexPath.item]
        let bookData = BookData(title: book.title, oldISBN: book.isbn, newISBN: book.isbn, cover: book.cover, releaseDate: book.releaseDate, notifiyRelease: book.releaseNotify)
        navigateToAddEditController(OperationType.edit, bookData)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeItemCell.itemSize.width, height: HomeItemCell.itemSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
