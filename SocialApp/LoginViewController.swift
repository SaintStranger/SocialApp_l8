//
//  LoginViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 30.09.2020.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInput.delegate = self
        passInput.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
    }
    
    
    @IBOutlet weak var appTitle: UILabel!
    
    
    @IBOutlet weak var bcgImage: UIImageView!
    
    
    @IBOutlet weak var logInput: UITextField!
    
    
    @IBOutlet weak var passInput: UITextField!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    func check() -> Bool {
        
        guard let login = logInput.text, let pass = passInput.text else {
            return false
        }
        
        if login == "admin" && pass == "hom3W0rk" {
            print("Успешная авторизация")
            
            let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarScreenViewController") as! TabBarScreenViewController
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            present(nextViewController, animated: true, completion: nil)
            
            return true
            
            }  else {
                
//            return false
                
                let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarScreenViewController") as! TabBarScreenViewController
                
                nextViewController.modalPresentationStyle = .fullScreen
                
                present(nextViewController, animated: true, completion: nil)
                
                return true
                
        }
        
    }
    
    
    func errorPopup() {
        
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные. Попробуйте еще раз", preferredStyle: .alert)
        
        let popupAction = UIAlertAction(title: "Понятно", style: .cancel, handler: nil)
        
        alert.addAction(popupAction)
     
        present(alert, animated: true, completion: nil)
        
    }
    
    
//    @IBAction func logButton(_ sender: Any) {
//
//        check()
//
//        let checkResult = check()
//
//        if !checkResult {
//            errorPopup()
//        }
//
//    }
    
    
    
    @objc func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if textField == logInput {
//            passInput.becomeFirstResponder()
//        } else {
//            check()
//        }
//        
        return true
        
    }
}
