//
//  DiseasesViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 10/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit
import Alamofire

class DiseasesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var continueButton: UIBarButtonItem!
    @IBOutlet weak var loaderView: UIView!
    func alertView(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoader() {
        UIView.animate(withDuration: 1) {
            self.loaderView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        continueButton.isEnabled = false
    }
    
    func stopLeader() {
        UIView.animate(withDuration: 1) {
            self.loaderView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        continueButton.isEnabled = true
    }
    
    @IBAction func continueAction(_ sender: Any) {
        startLoader()
        let params = ["email": RegisterUser.Name, "password": RegisterUser.Password, "age": RegisterUser.Age, "name": RegisterUser.Name] as [String : Any]
        Alamofire.request(base_url_signup, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { (response) in
            if response.result.isSuccess == true {
                if let a:NSDictionary = response.result.value! as? NSDictionary {
                    print(a)
                    if a["code"] as! Bool == false {
                        self.stopLeader()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.stopLeader()
                        self.alertView(title: "Authentication Error!", message: "Please check your login details")
                    }
                }
            } else {
                self.stopLeader()
                self.alertView(title: "Authentication Error!", message: "Please check your login details")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiseaseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flag = diseasesTableView.dequeueReusableCell(withIdentifier: "disease", for: indexPath) as! DiseaseTableViewCell
        flag.selectionStyle = .none
        flag.textLabel?.text = DiseaseList[indexPath.row].name
        return flag
    }

    @IBOutlet weak var diseasesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var temp = Diseases()
        for i in 0...(DiseaseListDatabase.count - 1) {
            temp.id = i
            temp.name = DiseaseListDatabase[i]
            DiseaseList.append(temp)
        }
        diseasesTableView.delegate = self
        diseasesTableView.dataSource = self
        self.diseasesTableView.allowsMultipleSelection = true
        self.diseasesTableView.allowsMultipleSelectionDuringEditing = true
    }
}
