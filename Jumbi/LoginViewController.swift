//
//  LoginViewController.swift
//  Jumbi
//
//  Created by dario on 03/06/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPass: UITextField!
    
    private let kEmail = "MY_EMAIL"
    private let kPass = "MY_PASS"
    
    var emailUser = ""
    var passUser = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmail.delegate = self
        lblPass.delegate = self
        isLogin()
    }
    
    

    @IBAction func btnPressedLogin(_ sender: Any) {
        
        if containsValuestoForm(){
            assignValuestoForm()
            if emailUser == UserDefaults.standard.string(forKey: kEmail) && passUser ==  UserDefaults.standard.string(forKey: kPass){
                performSegue(withIdentifier: "LoginSegue", sender: nil)
                
            }
            else{
                let alert = UIAlertController(title: "Ups, incorrect login", message: "Relax and fill those fields", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else{
            
            let alert = UIAlertController(title: "Ñamm", message: "Some field is empty ", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func isLogin(){
        guard let _ = UserDefaults.standard.string(forKey: kEmail),
            let _ = UserDefaults.standard.string(forKey: kPass) else {
            return performSegue(withIdentifier: "RegisterSegue", sender: nil)
        }
    }
    
    
    
    func assignValuestoForm() {
        if let email = lblEmail.text?.lowercased(){
            emailUser = email
        }
        if let pass = lblPass.text?.lowercased(){
            passUser = pass
        }
    }
    
    
    func containsValuestoForm() -> Bool{
        
        guard let email = lblEmail.text,
              let pass = lblPass.text ,
              !email.isEmpty,!pass.isEmpty else {
            return false
        }
        return true
    }
}
