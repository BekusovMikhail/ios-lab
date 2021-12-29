//
//  CoreDataManager.swift
//  SafePass.v2
//
//  Created by Mihail on 12/12/21.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllRecordings() -> [Recording] {
        do {
            let recordings = try context.fetch(Recording.fetchRequest())
            return recordings
        } catch{
            return []
        }
        
    }
    
    func getCustomRecording(companyName:String) -> Recording? {
        for i in getAllRecordings() {
            if i.company == companyName{
                return i
            }
        }
        return nil
    }
    
    func addNewRecording(company: String, login:String, password: String){
        let newRecording = Recording(context: context)
        newRecording.company = company
        newRecording.login = login
        newRecording.password = password
        do {
            try context.save()
        } catch {
            return
        }
    }
    
    func deleteRecording(recording: Recording){
        context.delete(recording)
        do {
            try context.save()
        } catch {
            return
        }
        
    }
    
    func updateRecording(recording: Recording, login:String, password: String){
        recording.login = login
        recording.password = password
        do {
            try context.save()
        } catch {
            return
        }
        
    }
    
    func checkIfLogged() -> Bool {
        var config: [Config]
        do {
            config = try context.fetch(Config.fetchRequest())
        } catch{
            return false
        }
        if config.count == 0{
            return false
        } else {
            return true
        }
        
    }
    
    func getConfig() -> Config? {
        do {
            let config = try context.fetch(Config.fetchRequest())
            return config[0]
        } catch{
            return nil
        }
    }
    
    func getConfigs() -> [Config] {
        do {
            let configs = try context.fetch(Config.fetchRequest())
            return configs
        } catch{
            return []
        }
    }
    func addConfig(name: String, surname: String, phone: String, password: String){
        let newConfig = Config(context: context)
        newConfig.name = name
        newConfig.surname = surname
        newConfig.phone = phone
        newConfig.password = password
        do {
            try context.save()
        } catch {
            return
        }
    }
    
    func updateConfig(config: Config, name:String, surname: String){
        config.name = name
        config.surname = surname
        do {
            try context.save()
        } catch {
            return
        }
        
    }
    func deleteConfig(config: Config){
        context.delete(config)
        do {
            try context.save()
        } catch {
            return
        }
        
    }
}
