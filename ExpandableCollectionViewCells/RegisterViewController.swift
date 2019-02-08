//
//  RegisterViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 09/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let fieldTypes = [
        "Name",
        "Age",
        "Email",
        "Password",
        "Confirm Password"
    ]
    
    var name = ""
    var age:Int = 0
    var email = ""
    var password = ""
    var confirmPassword = ""

    @IBOutlet weak var transitionView: UIStackView!
    @IBOutlet weak var fieldType: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var counter = 1
    
    func alertView(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if counter == fieldTypes.count {
            if password != confirmPassword {
                alertView(title: "Failed", message: "Password does not match")
                return
            }
        }
        if inputField.text != "" {
            switch counter-1 {
                case 0: name = inputField.text!
                case 1: age = Int(inputField.text!)!
                case 2: email = inputField.text!
                case 3: password = inputField.text!
                case 4: confirmPassword = inputField.text!
                default: print("Default")
            }
            inputField.text = ""
            if counter == fieldTypes.count {
                counter = 0
                performSegue(withIdentifier: "selectDiseases", sender: nil)
            }
            transitionView.alpha = 0.0
            UIView.animate(withDuration: 1, animations: {
                self.fieldType.text = self.fieldTypes[self.counter]
                self.transitionView.alpha = 1.0
            }) { (finished) in
                self.counter = self.counter + 1
            }
        } else {
            alertView(title: "Field Empty", message: "Please fill in the required information")
        }
        
    }
    
    @objc func dismissKeyboard() {
        inputField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard)))

    }
    
}
