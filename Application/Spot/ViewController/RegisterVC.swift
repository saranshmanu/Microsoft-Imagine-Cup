//
//  RegisterVC.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 09/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    let fieldTypes = [
        "Name",
        "Age",
        "Email",
        "Password",
        "Confirm Password"
    ]
    
    let fieldTypesSubheading = [
        "Let’s begin to know you.",
        "It’s good to know how wise you are.",
        "Use this for your username",
        "Its better to use secure passwords",
        "Confirm your password to begin with the application"
    ]
    
    var name = ""
    var age: Int = 0
    var email = ""
    var password = ""
    var confirmPassword = ""

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var transitionView: UIStackView!
    @IBOutlet weak var fieldType: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var counter = 0
    
    func alertView(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if inputField.text != "" {
            if counter == 0 {
                self.inputField.keyboardType = UIKeyboardType.numberPad
            } else {
                self.inputField.keyboardType = UIKeyboardType.alphabet
            }
            switch counter {
                case 0: name = inputField.text!
                case 1: age = Int(inputField.text!)!
                case 2: email = inputField.text!
                case 3: password = inputField.text!
                case 4: confirmPassword = inputField.text!
                default: print("Default")
            }
            if counter == fieldTypes.count-1 {
                if password != confirmPassword {
                    alertView(title: "Failed", message: "Password does not match")
                    return
                }
            }
            inputField.text = ""
            if counter == fieldTypes.count-1 {
                counter = 0
                RegisterUser.Name = name
                performSegue(withIdentifier: "selectDiseases", sender: nil)
            }
            transitionView.alpha = 0.0
            UIView.animate(withDuration: 1, animations: {
                self.fieldType.text = self.fieldTypes[self.counter + 1]
                self.subHeading.text = self.fieldTypesSubheading[self.counter + 1]
                self.transitionView.alpha = 1.0
            }) { (finished) in
                self.counter = self.counter + 1
            }
            if counter == 2 || counter == 3{
                inputField.isSecureTextEntry = true
            } else {
                inputField.isSecureTextEntry = false
            }
        } else {
            alertView(title: "Field Empty", message: "Please fill in the required information")
        }
        inputField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        inputField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard)))

    }
    
}
