//
//  RegisterViewController.swift
//  HackUCI2018
//
//  Created by Andrew Vo on 2/2/18.
//  Copyright © 2018 Team Alabama. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user = userDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if let email = emailTextField.text {
            user.userEmail = email
        }
        if let password = passwordTextField.text {
            user.userPassword = password
        }
        registerNewUser(email: user.userEmail, password: user.userPassword)
    }
    
    func registerNewUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                //success
                print("registration successful!")
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("yay log in successful")
                        self.configureNewUserDetails()
                    }
                }
            }
        }
    }
    
    func configureNewUserDetails() {
        user.remainingCalories = user.totalCalories
        let usersDB = Database.database().reference().child("Users")
        guard let myUserID = Auth.auth().currentUser?.uid else {return}
        let usersInfo = usersDB.child(myUserID)
        
        let usersInfoDict = ["UserEmail" : user.userEmail, "UserGender" : user.userGender, "UserWeight" : user.userWeight, "TotalCalories" : user.totalCalories, "RemainingCalories" : user.remainingCalories] as [String : Any]
        
        usersInfo.setValue(usersInfoDict)
    }
    
}
