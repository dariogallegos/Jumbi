//
//  RegisterViewController.swift
//  Jumbi
//
//  Created by Dev2 on 03/06/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{

    private let kEmail = "MY_EMAIL"
    private let kPass = "MY_PASS"
    private let kName = "MY_NAME"
    
    var emailUser = ""
    var nameUser = ""
    var passwordUser = ""
    
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.delegate = self
        lblEmail.delegate = self
        lblPassword.delegate = self
        
    }
    
    
    @IBAction func btnPressedRegister(_ sender: Any) {
        
        if containsValuestoForm(){
            debugPrint("El form contiene valores ")
            assignValuestoForm()
            setValuesUserDefualts(name: nameUser, email: emailUser, password: passwordUser)
            performSegue(withIdentifier: "LoginFromRegisterSegue", sender: nil)
        }
        else{
            
            let alert = UIAlertController(title: "Nope", message: "Some field is empty, please check it ", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "Ok, I understand", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    func setValuesUserDefualts(name: String, email: String, password: String){
        
        UserDefaults.standard.set(name, forKey: kName)
        UserDefaults.standard.set(email, forKey: kEmail)
        UserDefaults.standard.set(password, forKey: kPass)
        UserDefaults.standard.synchronize()
        
    }
    
    
    func assignValuestoForm() {
        if let email = lblEmail.text?.lowercased(){
            emailUser = email
        }
        if let password = lblPassword.text?.lowercased(){
            passwordUser = password
        }
        if let name = lblName.text?.lowercased(){
            nameUser = name
        }
    }
    
    
    func containsValuestoForm() -> Bool{
        guard let email = lblEmail.text,
            let pass = lblPassword.text ,
            let name = lblEmail.text,
            !email.isEmpty,!pass.isEmpty,!name.isEmpty else {
                return false
        }
        return true
    }
    
}
