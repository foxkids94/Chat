//
//  MyProfile.swift
//  Chat
//
//  Created by Юрий Макаров on 11.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit

class MyProfile: UIViewController {
    
    
    @IBAction func Dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var MyName: UILabel!
    @IBOutlet weak var MyId: UILabel!
    
    override func viewDidLoad() {
        MyName.text = DataSourse.shared.MyName
        MyId.text = DataSourse.shared.myID
    }

}
