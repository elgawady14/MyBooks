//
//  LoginController.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 20/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTF: UITextField! {
        didSet {
            emailTF.becomeFirstResponder()
            emailTF.delegate = self
        }
    }
    @IBOutlet weak var passwordTF: UITextField! {
        didSet {
            passwordTF.delegate = self
        }
    }
    @IBOutlet weak var secureImg: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!

    var indicator: LoadingView?
    
    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        guard indicator == nil else { return }
        indicator = LoadingView(yOrigin: loginBtn.frame.origin.y - 25, theSuperView: view)
    }

    @IBAction func secureBtnAction() {
        secureImg.alpha = secureImg.alpha == 1 ? 0.5 : 1
        passwordTF.isSecureTextEntry = secureImg.alpha == 1 ? false : true
    }
    
    @IBAction func loginAction() {
      
        guard !emailTF.text!.isEmpty, !passwordTF.text!.isEmpty else { return }
        
        guard emailTF.text!.isValidEmail else {
            self.showMessage(title: "⚠️", msg: "Enter a valid email (ex@domain.com)")
            return
        }
        view.endEditing(true)
        indicator!.startAnimating()
        loginBtn.isEnabled = false

        // just simulate loading.
        delay(1.0) {
            self.checkoutUser(self.emailTF.text!)
            self.loginBtn.isEnabled = true
        }
    }
}

extension LoginController {
    
    func presentHomePage() {
        
        guard let _ = userDefaultsHandler.getUserEmail() else { return }
        guard let homeNavigation = mainStoryboard.instantiateViewController(withIdentifier: Constants.StoryBoardKeys.HomeNavigation) as? UINavigationController else { return }
        present(homeNavigation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
