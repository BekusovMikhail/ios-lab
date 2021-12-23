//
//  RegisterViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/7/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    var db = Firestore.firestore()
    
    @IBOutlet weak var incorrectStatus: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var smsCodeTF: UITextField!
    @IBOutlet weak var subPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var regLabel: UILabel!
    @IBOutlet weak var surnameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonChange(_ sender: Any) {
        if (smsCodeTF.isHidden == true) {
            if (nameTF.text != "" &&
            surnameTF.text != "" &&
            phoneTF.text != "" &&
            passwordTF.text != "" &&
            subPasswordTF.text != ""){
                incorrectStatus.text = ""
                if (passwordTF.text != subPasswordTF.text){
                    incorrectStatus.text = "Password mismatch"
                    return
                }
                
                db.collection("users").document(self.phoneTF.text!).getDocument { document, error in
                     if error == nil{
                         if (document != nil && document!.exists){
                             self.incorrectStatus.text = "This phone already registered"
                             return
                         }
                     }
                 }
                incorrectStatus.text = ""
                incorrectStatus.text = "Enter SMS-Code"
                
                signUpButton.setTitle("Confirm", for: .normal)
                AuthManager.shared.verifyPhone(self.phoneTF.text!){
                    [weak self] success in
                    guard success else { return }
                }
                
                smsCodeTF.isHidden = false
                nameTF.isUserInteractionEnabled = false
                surnameTF.isUserInteractionEnabled = false
                phoneTF.isUserInteractionEnabled = false
                passwordTF.isUserInteractionEnabled = false
                subPasswordTF.isUserInteractionEnabled = false
                
            } else {
            incorrectStatus.text = "Incorrect input"
        }
        
        } else {
            AuthManager.shared.verifyCode(self.smsCodeTF.text!) { [weak self] success in
                guard success else
                { self!.incorrectStatus.text = "Incorrect SMS-Code"
                    return }
                self!.db.collection("users").document(self!.phoneTF.text!).setData(["password":self!.passwordTF.text, "name":self!.nameTF.text, "surname": self!.surnameTF.text, "keys": [:]])
                self!.performSegue(withIdentifier: "toMain", sender: nil)
                
            }
        }
        
    }
    
    

}
