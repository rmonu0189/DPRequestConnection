//
//  ViewController.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 20/11/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginUser()

    }

    func loginUser() {
        let user = User(email: "email@example.com", password: "password")
        APIService.login(user: user).submit { (response) in
            print(response)
        }
    }

}

