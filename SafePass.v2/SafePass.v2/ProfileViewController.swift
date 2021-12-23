//
//  ProfileViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var passwordChangeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nameAndSurname: UILabel!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTF.text = coreData.getConfig()?.name
        self.surnameTF.text = coreData.getConfig()?.surname
        self.nameTF.isHidden = true
        self.surnameTF.isHidden = true
        self.confirmButton.isHidden = true
        self.statusLabel.isHidden = true
        self.statusLabel.text = ""
        
        
        var nameSurname = coreData.getConfig()?.name
        nameSurname! += " "
        nameSurname! += (coreData.getConfig()?.surname)!
        nameAndSurname.text = nameSurname
        let btnEdit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(goToEdit))
        navigationItem.rightBarButtonItem = btnEdit
        
    }
  
    @objc func goToEdit() {
        
        confirmButton.isHidden = false
        nameTF.isHidden = false
        surnameTF.isHidden = false
        statusLabel.isHidden = false
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if nameTF.text != "" && surnameTF.text != ""{
            coreData.updateConfig(config: coreData.getConfig()!, name: nameTF.text!, surname: surnameTF.text!)
            uploadData()
            self.viewDidLoad()
        } else{
            statusLabel.text = "Name or surname is empty"
            return
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let dvc = segue.
        
    }
    
    @IBAction func passwdChangeTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toChangePassword", sender: nil)
    }
    
    @IBAction func quitButtonTapped(_ sender: Any) {
        for i in coreData.getConfigs(){
            coreData.deleteConfig(config: i)
        }
        for i in coreData.getAllRecordings(){
            coreData.deleteRecording(recording: i)
        }
        self.performSegue(withIdentifier: "toLoginFromProfile", sender: nil)
        
    }
}
