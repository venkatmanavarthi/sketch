//
//  PrimaryDrawingViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase

class PrimaryDrawingViewController : UITableViewController{
    var drawings : [Drawing] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Drawings"
        self.view.backgroundColor = .systemBackground
        tableView.register(DrawingCell.self, forCellReuseIdentifier: "drawingCell")
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(openNewSlate)), animated: true)
        guard let user_email = Auth.auth().currentUser?.email else{
            return
        }
        db.collection(user_email).order(by: "date").addSnapshotListener { (querySnapShot, error) in
            self.drawings = []
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
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    @objc func openNewSlate(){
        let slateVc = SlateViewController()
        navigationController?.pushViewController(slateVc, animated: true)
    }
}
//MARK: - TableView DataSource
extension PrimaryDrawingViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawingCell", for: indexPath) as! DrawingCell
        cell.textLabel?.text = drawings[indexPath.row].title
        cell.leftImageView.loadImage(urlString: drawings[indexPath.row].url)
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawings.count
    }
}
//MARK: - TableView Delegate
extension PrimaryDrawingViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        let viewPICVC = DrawingViewerViewController()
        viewPICVC.data = drawings[selectedRow]
        navigationController?.pushViewController(viewPICVC, animated: true)
    }
}

