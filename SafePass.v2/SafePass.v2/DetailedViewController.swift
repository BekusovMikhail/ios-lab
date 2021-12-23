//
//  DetailedViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/10/21.
//

import UIKit
import Firebase

class DetailedViewController: UIViewController {
    var label: String?
    
    var login:String?
    
    @IBOutlet weak var LoginL: UILabel!
    @IBOutlet weak var NameL: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var PasswordL: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editingLogin: UITextField!
    @IBOutlet weak var editingPassword: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editButton.setTitle("Edit", for: .normal)
        self.editingLogin.isUserInteractionEnabled = false
        self.editingPassword.isUserInteractionEnabled = false
    
        label1.text = label
        
        self.editingLogin.text = coreData.getCustomRecording(companyName: label1.text!)!.login
        self.editingPassword.text = coreData.getCustomRecording(companyName: label1.text!)!.password
        
        }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if editButton.currentTitle == "Edit" {
        self.editingLogin.isUserInteractionEnabled = true
        self.editingPassword.isUserInteractionEnabled = true
        self.editButton.setTitle("Confirm", for: .normal)
        } else {
                if (self.editingPassword.text == "" || self.editingLogin.text == "") {
                    self.statusLabel.text = "Login or password is empty"
                    return
                    
                }
                var neededRecording = coreData.getCustomRecording(companyName: label1.text!)!
                coreData.updateRecording(recording: neededRecording, login: self.editingLogin.text!, password: self.editingPassword.text!)
                uploadData()
                self.viewDidLoad()
            }
    }
        
    
}
