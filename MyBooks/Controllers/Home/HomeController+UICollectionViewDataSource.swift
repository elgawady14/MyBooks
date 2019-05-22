//
//  HomeController+UICollectionViewDataSource.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension HomeController: UICollectionViewDataSource {
    
    // MARK:- DATASOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueCell(HomeItemCell.self, indexPath) else { return UICollectionViewCell() }
        cell.configure(indexPath.item, delegate: self)
        return cell
    }
}
