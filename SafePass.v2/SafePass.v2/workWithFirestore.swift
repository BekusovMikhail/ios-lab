//
//  workWithFirestore.swift
//  SafePass.v2
//
//  Created by Mihail on 12/12/21.
//

import Foundation

import Firebase
import FirebaseAuth

var db = Firestore.firestore()

func downloadData(){
    
}

func uploadData(){
    let document = db.collection("users").document((coreData.getConfig()?.phone)!)
    
    var keysMap :[String:[String:String]] = [:]
    
    for i in coreData.getAllRecordings(){
        let logpas:[String:String] = ["login":i.login!,"password":i.password!]
        keysMap[i.company!] = logpas
    }
    
    document.setData(["name":coreData.getConfig()?.name, "surname":coreData.getConfig()?.surname, "password":coreData.getConfig()?.password, "keys":keysMap])
}

class AuthManager {
    static let shared = AuthManager()
    
    var verificationId: String?
    
    func verifyPhone(_ phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(
            phoneNumber,
            uiDelegate: nil
        ) { [weak self] verificationId, error in
            guard let verificationId = verificationId,
                  error == nil
            else {
                completion(false)
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    func verifyCode(_ smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = self.verificationId else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            guard result != nil,
                  error == nil
            else {
                completion(false)
                return
            }
    
            completion(true)
        }
    }

}
