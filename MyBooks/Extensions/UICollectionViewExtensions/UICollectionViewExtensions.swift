//
//  UICollectionViewExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/28/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func dequeueCell<CellOrView: NSObject>(_ type: CellOrView.Type, _ indexPath: IndexPath?) -> CellOrView? {
        
        if type.superclass() == UICollectionViewCell.self {
            return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath!) as? CellOrView
        } else if type.superclass() == UICollectionReusableView.self {
            return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type), for: indexPath!) as? CellOrView
        } else { return nil }
        // footer not supported yet,
    }
    
    func registerNib<CellOrView: NSObject>(className: CellOrView.Type) {
        
        let classStr = String(describing: className)
        let nib = UINib(nibName: classStr, bundle: nil)
        
        if className.superclass() == UICollectionViewCell.self {
            register(nib, forCellWithReuseIdentifier: classStr)
        } else if className.superclass() == UICollectionReusableView.self {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: classStr)
        }
        // footer not supported yet,
    }
    
    func setLayout(top: CGFloat,left: CGFloat,bottom: CGFloat,right: CGFloat,width: CGFloat?,height: CGFloat?) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        if let _ = width, let _ = height {
            layout.itemSize = CGSize(width: width!, height: height!)
        }
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewLayout = layout
    }
}
