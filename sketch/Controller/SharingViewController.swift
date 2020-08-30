//
//  SharingViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase

class SharingViewController : UIViewController{
    var drawings : [Drawing] = []
    var allDrawings : [Drawing] = []
    private let db = Firestore.firestore()
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search By Name"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shared Works"
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DrawingCell.self, forCellReuseIdentifier: "sharingCell")
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        guard let _ = Auth.auth().currentUser?.email else{
                   return
               }
               db.collection("sharing").order(by: "date").addSnapshotListener { (querySnapShot, error) in
                   self.drawings = []
                self.allDrawings = []
                   if let e = error{
                       print(e, "issue data retriving")
                       return
                   }else{
                       if let snapShotDocuments  = querySnapShot?.documents{
                           for doc in snapShotDocuments{
                               let data = doc.data()
                               if let title = data["title"] as? String,
                                   let url = data["url"] as? String,let email = data["email"] as? String{
                                   let dr = Drawing(email: email, url: url, title: title)
                                   self.drawings.append(dr)
                                self.allDrawings.append(dr)
                                   self.tableView.reloadData()
                               }
                           }
                       }
                   }
               }
    }
}
extension SharingViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        let viewPICVC = DrawingViewerViewController()
        viewPICVC.data = drawings[selectedRow]
        navigationController?.pushViewController(viewPICVC, animated: true)
    }
}
extension SharingViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharingCell", for: indexPath) as! DrawingCell
        cell.textLabel?.text = drawings[indexPath.row].title
        cell.leftImageView.loadImage(urlString: drawings[indexPath.row].url)
        return cell
    }
    
    
}
extension SharingViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            drawings = allDrawings
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else if searchBar.text != nil && searchBar.text != ""{
            drawings = allDrawings.filter {
                $0.title.range(of: searchBar.text!, options: .caseInsensitive) != nil
            }
            tableView.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
