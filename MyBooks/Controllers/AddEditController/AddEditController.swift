//
//  AddEditController.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

enum OperationType {
    case add
    case edit
}
class AddEditController: UIViewController {

    var operationType = OperationType.add
    var selectedBook: Book?
    override func viewDidLoad() {
        super.viewDidLoad()
        preSettings()
    }
}


extension AddEditController {
    
    func preSettings() {
        
        navigationItem.title = operationType == .add ? "New Book" : "\(selectedBook?.title ?? "Update Book")"
        navigationController?.navigationBar.tintColor = .black
    }
}
