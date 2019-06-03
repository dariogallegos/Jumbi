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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("da", forKey: kEmail)
        UserDefaults.standard.set("da", forKey: kPass)
        UserDefaults.standard.synchronize()
        
        // Do any additional setup after loading the view.
    }

}
