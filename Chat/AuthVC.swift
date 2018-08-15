//
//  AuthVC.swift
//  Chat
//
//  Created by Юрий Макаров on 14.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid != nil {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "vcStart")
        self.navigationController?.present(vc, animated: true, completion: nil)
        } else { return }
    }
    

    @IBAction func SignIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: passwd.text!, completion: { (result, error) in
            guard error != nil else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "vcStart")
                self.navigationController?.present(vc, animated: true, completion: nil)
                
                return }
            let alertError = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertError.addAction(action)
            self.present(alertError, animated: true, completion: nil)
            
            })
        }
}
