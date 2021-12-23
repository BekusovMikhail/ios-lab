//
//  RootViewController.swift
//  SafePass.v2
//
//  Created by Mihail on 12/7/21.
//

import UIKit
import Firebase


class RootViewController: UIViewController {
    var login:String?
    var name: String?
    let idCell = "mainCell"
    var search: UISearchController?
    @IBOutlet weak var mainTable: UITableView!
    
    let db = Firestore.firestore()
    
    var data: [String] = []
    
    var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // login = userPhoneNumber
//       db.collection("users").document(self.login!).getDocument { document, error in
//            if error == nil{
//                if (document != nil && document!.exists){
//                    let documentData = document!.data()
//                    var passwords : [String:String] = documentData?["keys"] as! [String : String]
//                    var companyNames : [String] = Array(passwords.keys)
//                    self.data = companyNames
//                    self.mainTable.reloadData()
//                } else {
//                    print("Document doesn't exists")
//                }
//            }
//        }
////        self.data = self.getCompanies()
//        print(self.data)
        
        let d = coreData.getAllRecordings()
        for i in d {
            data.append(i.company!)
        }
        //print(data)
        
        mainTable.dataSource = self
        mainTable.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        search = UISearchController(searchResultsController: nil)
        search!.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesBackButton = true
        let btnAdd = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(goToAdd))
        let image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        let btnProfile = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItems = [btnAdd, btnProfile]
        
        
    }
    
    
    @objc func goToAdd(){
        
        self.performSegue(withIdentifier: "toAdd", sender: nil)
    }
    @objc func goToProfile(){
        
        self.performSegue(withIdentifier: "toProfile", sender: nil)
        
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete" ) { (action, view, success) in
            var recordings: [Recording] = coreData.getAllRecordings()
            coreData.deleteRecording(recording: recordings[indexPath.row])
            uploadData()
            self.data.remove(at: indexPath.row)
            self.mainTable.reloadData()
        }
        swipeDelete.image = UIImage(named: "trash")?.withRenderingMode(.alwaysOriginal)
        swipeDelete.backgroundColor = UIColor.red
        let conf = UISwipeActionsConfiguration(actions: [swipeDelete])
        conf.performsFirstActionWithFullSwipe = false
        return conf
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let dvc = segue.
        if (segue.identifier == "toDetailed"){
            guard let dvc = segue.destination as? DetailedViewController else {return}
            dvc.label = self.name
        }
    }
    
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (search!.isActive) {
              return filteredData.count
          } else {
              return data.count
          }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = mainTable.dequeueReusableCell(withIdentifier: idCell)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idCell)
        }
        if (search!.isActive) {
            cell!.textLabel!.text = filteredData[indexPath.item]
          }
        else {
            cell!.textLabel!.text = data[indexPath.item]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  (search!.isActive) {
            self.name =  filteredData[indexPath.item]
          } else {
            self.name = data[indexPath.item]
          }
        self.performSegue(withIdentifier: "toDetailed", sender: nil)
    }
    
    
}

extension RootViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredData.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", search!.searchBar.text!)
        let array = (data as NSArray).filtered(using: searchPredicate)
        filteredData = array as! [String]

        self.mainTable.reloadData()
        
    }
    
}

