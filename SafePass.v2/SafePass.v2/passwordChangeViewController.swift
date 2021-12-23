//
//  passwordChangeViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/21/21.
//

import UIKit
import Firebase

class passwordChangeViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var checkNewPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var previousPassword: UITextField!
    var newPSWD : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNewPassword.placeholder = "Confirm new password"
        newPassword.placeholder = "New password"
        previousPassword.placeholder = "Previous password"
        previousPassword.isHidden = false
        newPassword.isHidden = false
        confirmButton.setTitle("Send me SMS", for: .normal)
        statusLabel.text = ""
        previousPassword.text = ""
        newPassword.text = ""
        checkNewPassword.text = ""
        
        
    }
    

    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.statusLabel.text = ""
        var pswd : String = ""
        
        
        
        db.collection("users").document((coreData.getConfig()?.phone)!).getDocument {document, error in
         if error == nil{
             if (document != nil && document!.exists){
                 let documentData = document!.data()
                 pswd = documentData?["password"] as! String
                 
                 
                 if self.confirmButton.currentTitle == "Send me SMS" {
                     if self.checkNewPassword.text != "" && self.newPassword.text != "" && self.previousPassword.text != "" {
                         if self.previousPassword.text == pswd {
                             if self.checkNewPassword.text != self.newPassword.text {
                                 self.statusLabel.text = "New password mismatch"
                                 return
                             } else {
                                 DispatchQueue.main.async { AuthManager.shared.verifyPhone((coreData.getConfig()?.phone)!) {
                                         [weak self] success in
                                         guard success else { return }
                                 }
                                 }
                                 self.statusLabel.text = "SMS-code is sent"
                                 self.newPSWD = self.newPassword.text!
                                 self.previousPassword.isHidden = true
                                 self.newPassword.isHidden = true
                                 self.checkNewPassword.text = ""
                                 self.checkNewPassword.placeholder = "SMS-code"
                                 self.confirmButton.setTitle("Confirm", for: .normal)
                                 return
                             }
                         } else {
                             self.statusLabel.text = "Incorrect previous password"
                             return
                         }
                     } else {
                         self.statusLabel.text = "Fill all spaces"
                         return
                     }
                     
                 } else {
                     var flag: Bool = true
                     DispatchQueue.main.async {
                         AuthManager.shared.verifyCode(self.checkNewPassword.text!) {[weak self] success in
                             guard success else {
                                 self!.statusLabel.text = "SMS-code is incorrect"
                                 flag = false
                                 return
                             }
                             coreData.getConfig()?.password = self?.newPSWD
                             uploadData()
                             self?.viewDidLoad()
                             
                         }
                     }
                     
                    
                 }
                 
                 
             } else {
                 self.statusLabel.text = "No document"
             }
         } else {
             self.statusLabel.text = "No internet"
         }
            
        }
        
    }
}
