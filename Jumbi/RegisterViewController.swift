//
//  RegisterViewController.swift
//  Jumbi
//
//  Created by Dev2 on 03/06/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    private let kEmail = "MY_EMAIL"
    private let kPass = "MY_PASS"
    var emailUser = ""
    var nameUser = ""
    var passwordUser = ""
    
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("da", forKey: kEmail)
        UserDefaults.standard.set("da", forKey: kPass)
        UserDefaults.standard.synchronize()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnPressedRegister(_ sender: Any) {
        
    }
    
    
    func assignValuestoForm() {
        if let email = lblEmail.text?.lowercased(){
            emailUser = email
        }
        if let password = lblPassword.text?.lowercased(){
            passwordUser = password
        }
    }
    
    
    func containsValuestoForm() -> Bool{
        guard let email = lblEmail.text,
            let pass = lblPassword.text ,
            !email.isEmpty,!pass.isEmpty else {
                return false
        }
        return true
    }
    
}
