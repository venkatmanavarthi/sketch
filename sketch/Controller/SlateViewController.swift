//
//  ViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 27/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase

class SlateViewController: UIViewController {
    private var nameTextField = UITextField()
    private let storage = Storage.storage()
    let db = Firestore.firestore()
    private let colors : [UIColor] = [UIColor.white,UIColor.black,UIColor.red,UIColor.green,UIColor.gray,UIColor.systemPink,UIColor.orange,UIColor.brown,UIColor.yellow,UIColor.blue]
    //stroke slider used to increse or decrese the width of the stroke
    private let strokeSlider : UISlider = {
       let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 10
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(widthSliderValue(sender:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    private let eraser : UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "clear"), for: .normal)
        button.addTarget(self, action: #selector(eraserActivate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let opacitySlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(opacitySliderValue(sender:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var slate = Slate()
    let undoButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "undo"), for: .normal)
        button.addTarget(self, action: #selector(undoClicked), for: .touchUpInside)
        return button
    }()
    let clearButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("clear", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        return button
    }()
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return button
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(slate)
        slate.frame = view.frame
        slate.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        [undoButton,clearButton,eraser,collectionView,opacitySlider,strokeSlider,saveButton,backButton].forEach(view.addSubview)
        [undoButton,eraser,backButton].forEach { (button) in
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        }
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            clearButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            undoButton.trailingAnchor.constraint(equalTo: self.clearButton.leadingAnchor, constant: -20),
            undoButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            eraser.trailingAnchor.constraint(equalTo: self.undoButton.leadingAnchor, constant: -20),
            eraser.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            strokeSlider.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: 0),
            strokeSlider.widthAnchor.constraint(equalToConstant: 200),
            strokeSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            opacitySlider.bottomAnchor.constraint(equalTo: self.strokeSlider.topAnchor, constant: 0),
            opacitySlider.widthAnchor.constraint(equalToConstant: 200),
            opacitySlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            saveButton.trailingAnchor.constraint(equalTo: self.eraser.leadingAnchor, constant: -20),
            saveButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    @objc func undoClicked(){
        _ = slate.lines.popLast()
        slate.setNeedsDisplay()
    }
    @objc func clearClicked(){
        slate.lines.removeAll()
        slate.setNeedsDisplay()
    }
    @objc func eraserActivate(){
        let indexPaths = collectionView.indexPathsForSelectedItems
        eraser.layer.borderColor = UIColor.red.cgColor
        eraser.layer.borderWidth = 1
        if let selectedIndexPaths = indexPaths{
            collectionView.deleteItems(at: selectedIndexPaths)
        }
        if !opacitySlider.isHidden{
            opacitySlider.isHidden = true
        }
        slate.changeStrokeColor(color: UIColor.white.cgColor)
        slate.changeOpacity(value: 1)
    }
    //MARK: - slider Value Changed
    @objc func opacitySliderValue(sender : UISlider){
        print(sender.value)
        slate.changeOpacity(value: sender.value)
    }
    @objc func widthSliderValue(sender : UISlider){
        print(sender.value)
        slate.changeLineWidth(value: sender.value)
    }
    @objc func saveButtonPressed(){
        let alert = UIAlertController(title: "Sketch", message: "Please select a method to save your work", preferredStyle: .alert)
        let actionSave = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            self.saveImageToDb(type: 0)
        }
        let actionSaveAndShare = UIAlertAction(title: "Save & Share", style: .default) { (saveAndShareAction) in
            self.saveImageToDb(type: 1)
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Name for drawing"
            self.nameTextField = textField
        }
        alert.addAction(actionSave)
        alert.addAction(actionSaveAndShare)
        present(alert,animated: true)
    }
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    //0 means save only
    //1 means save and share
    func saveImageToDb(type : Int){
        let storageRef = storage.reference()
        print(nameTextField.text!)
        if nameTextField.text == nil || nameTextField.text == ""{
            alert(with: "Please give a Proper Name")
            return
        }
        guard let data = self.slate.asImage().pngData() else{
            return
        }
        print("images/\(Auth.auth().currentUser!.email!)\(nameTextField.text!).png")
        let ref = storageRef.child("images/\(Auth.auth().currentUser!.email!)\(nameTextField.text!).png")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = ref.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            self.alert(with: error!.localizedDescription)
            return
          }
          let size = metadata.size
          ref.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            self.db.collection("\(Auth.auth().currentUser!.email!)").addDocument(data: ["email":Auth.auth().currentUser!.email!,"title": self.nameTextField.text!,"date":Date().timeIntervalSince1970,"url":downloadURL.absoluteString]) { (error) in
                if let e = error{
                    self.alert(with: e.localizedDescription)
                    return
                }
            }
            if type == 1{
                self.db.collection("sharing").addDocument(data: ["email":Auth.auth().currentUser!.email!,"title": self.nameTextField.text!,"date":Date().timeIntervalSince1970,"url":downloadURL.absoluteString]) { (error) in
                    if let e = error{
                        self.alert(with: e.localizedDescription)
                        return
                    }else{
                        let alert = UIAlertController(title: "Sketch", message: "Your File Has Been Succesfully Uploaded and Shared", preferredStyle: .alert)
                        let action = UIAlertAction(title: "ok", style: .default) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(action)
                        self.present(alert,animated: true)
                    }
                }
            }else{
                let alert = UIAlertController(title: "Sketch", message: "Your File Has Been Succesfully Uploaded", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert,animated: true)
            }
          }
        }
    }
}
extension SlateViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if opacitySlider.isHidden{
            eraser.layer.borderWidth = 0
            opacitySlider.isHidden = false
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.layer.borderColor = UIColor.red.cgColor
        slate.changeStrokeColor(color: (cell?.backgroundColor!.cgColor)!)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.layer.borderColor = UIColor.gray.cgColor
    }
}
extension SlateViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.gray.cgColor
        
        if indexPath.row == 1{
            cell.layer.borderColor = UIColor.red.cgColor
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        return cell
    }
}
extension SlateViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
}

