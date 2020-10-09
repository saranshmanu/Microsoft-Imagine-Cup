//
//  LoginViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 08/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperConstraint: NSLayoutConstraint!
    
    func alertView(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard)))
    }

    func changeControls(flag: Bool) {
        skipButton.isEnabled = flag
        createAccountButton.isEnabled = flag
        loginButton.isEnabled = flag
        skipButton.isEnabled = flag
        usernameTextField.isEnabled = flag
        passwordTextField.isEnabled = flag
        activityIndicator.isHidden = flag
    }
    
    @IBAction func skipAuthenticationAction(_ sender: Any) {
        products.removeAll()
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            changeControls(flag: false)
            let params = ["email": usernameTextField.text!, "password": passwordTextField.text!] as [String : Any]
            Alamofire.request(base_url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { (response) in
                if response.result.isSuccess == true {
                    if let a:NSDictionary = response.result.value! as? NSDictionary {
                        if a["code"] as! Int == 0 {
                            self.changeControls(flag: true)
                            self.skipAuthenticationAction((Any).self)
                        } else {
                            self.changeControls(flag: true)
                            self.alertView(title: "Authentication Error!", message: "Please check your login details")
                        }
                    }
                    self.changeControls(flag: true)
                    self.alertView(title: "Authentication Error!", message: "Please check your login details")
                }
                self.changeControls(flag: true)
                self.alertView(title: "Authentication Error!", message: "Please check your login details")
            }
        } else {
            alertView(title: "Field Empty", message: "Please fill in the required information")
        }
    }
    
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    var constant:CGFloat = 150.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.upperConstraint.constant -= self.constant
            self.bottomConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.usernameTextField.isEditing || self.passwordTextField.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.upperConstraint.constant += self.constant
                self.bottomConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

}
