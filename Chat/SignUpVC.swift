//
//  SignUpVC.swift
//  Chat
//
//  Created by Юрий Макаров on 15.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var blure: UIVisualEffectView!
    var arrayTextFields: [UITextField] = []
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.blure.alpha = 0.9
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createUserProfile(_ sender: UIButton) {
            if name.text != "" {
                Auth.auth().createUser(withEmail: email.text!, password: passwd.text!, completion: { (result, error) in
                    guard error != nil else {
                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                        request?.displayName = self.name.text
                        request?.commitChanges(completion: nil)
                        return }
                    let alertError = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                    alertError.addAction(action)
                    self.present(alertError, animated: true, completion: nil)
                })
            } else {
            let alertError = UIAlertController(title: "Error", message: "Вы не заполнили все поля", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertError.addAction(action)
            self.present(alertError, animated: true, completion: nil)
            }
    }

}
