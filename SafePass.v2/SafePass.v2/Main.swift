//
//  ViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/7/21.
//

import UIKit
import Firebase

func check_func(vc: ViewController){
    
    let db = Firestore.firestore()
    
    if (vc.phoneTF.text == "" || vc.passwordTF.text == ""){
        vc.statusLabel.text = "Phone or password is empty"
        return
    }
    
    DispatchQueue.main.async{
        db.collection("users").document(vc.phoneTF.text!).getDocument { document, error in
         if error == nil{
             if (document != nil && document!.exists){
                 let documentData = document!.data()
                 let pswd : String = documentData?["password"] as! String
                 if pswd == vc.passwordTF.text {
                     for i in coreData.getConfigs(){
                         coreData.deleteConfig(config: i)
                     }
                     for i in coreData.getAllRecordings(){
                         coreData.deleteRecording(recording: i)
                     }
                            
                     coreData.addConfig(name: documentData?["name"] as! String, surname: documentData?["surname"] as! String, phone: vc.phoneTF.text!, password: documentData?["password"] as! String)
                     var data = documentData?["keys"] as! [String: [String:String]]
                     for i in data.keys {
                         coreData.addNewRecording(company: i, login:data[i]!["login"]!, password: data[i]!["password"]!)
                     }
                     vc.performSegue(withIdentifier: "toRoot", sender: nil)
                 } else {
                     vc.statusLabel.text = "Password is incorrect"
                     return
                 }
             } else {
                 vc.statusLabel.text = "Phone is not registered"
                 return
             }
         }
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var regButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func regTapped(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: nil)
        
    }
    @IBAction func logInTapped (_ sender: UIButton){
        check_func(vc:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let dvc = segue.
        if (segue.identifier == "toRoot"){
            let navVC = segue.destination as? UINavigationController
            let tableVC = navVC?.viewControllers.first as! RootViewController
            tableVC.login = self.phoneTF.text
//            userPhoneNumber = self.phoneTF.text!
//            //navigationController?.pushViewController(dest, animated: true)
//            guard let dvc = segue.destination as? RootViewController else {
//                print("Cast is broken")
//                return
//            }
//            dvc.login = self.phoneTF.text
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }

}

