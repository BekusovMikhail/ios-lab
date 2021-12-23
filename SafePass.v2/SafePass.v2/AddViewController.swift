//
//  AddViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/10/21.
//

import UIKit
import Firebase

class AddViewController: UIViewController {

    var db = Firestore.firestore()
    
    @IBOutlet weak var namePasswordTF: UITextField!
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var addingStatus: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtonAction(_ sender: Any) {
        if self.namePasswordTF.text != "" && self.passwordTF.text != "" && self.loginTF.text != "" {
            for i in coreData.getAllRecordings(){
                if i.company == namePasswordTF.text {
                    addingStatus.text = "Password from this company already exists"
                    return
                }
            }
            coreData.addNewRecording(company: namePasswordTF.text!, login: loginTF.text!, password: passwordTF.text!)
            uploadData()
            self.performSegue(withIdentifier: "toRootfromAdd", sender: nil)
        } else {
            self.addingStatus.text = "Name of password or password or login is empty"
            return
        }
    }
    
}
