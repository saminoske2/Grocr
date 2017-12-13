//
//  SignInViewController.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    var data = GroceryData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            //2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: "ShowGorceryList", sender: self)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Actions
    @IBAction func loginButton(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signupButton(_ sender: Any) {
       // shows alert controller to register users
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "save", style: .default) { action in
            
            // 1
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            //2
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) {user, error in
                if error == nil {
                    //3
                    FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {action in }
        
        // provides the alert window with a text box and states the placeholder text with text
        alert.addTextField { textEmail in textEmail.placeholder = "Enter your email"}
        
        // provides again the alert window with another text box and states the placeholder text with text, also provides the inputed text with security
        alert.addTextField { textPassword in textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        // actions of the alert controller
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
    }
}


// to add onto the exsiting code, you will use the word "extension (and the current viewController class name): (its style of use){}"
extension SignInViewController: UITextFieldDelegate {
        
        // the finction to make the text switch to other textfield once enter is pressed. once enter is pressed in the last text box, the text dissapears.
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            }
            if textField == passwordTextField{
                textField.resignFirstResponder()
            }
            return true
        }
    }
