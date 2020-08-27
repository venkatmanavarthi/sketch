//
//  ViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 27/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit

class SlateViewController: UIViewController {
    fileprivate let colors : [UIColor] = [UIColor.white,UIColor.black,UIColor.red,UIColor.green,UIColor.gray,UIColor.systemPink,UIColor.orange,UIColor.brown,UIColor.yellow,UIColor.blue]
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(slate)
        slate.frame = view.frame
        slate.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        [undoButton,clearButton,collectionView].forEach(view.addSubview)
        [undoButton,clearButton].forEach { (button) in
            button.heightAnchor.constraint(equalToConstant: 35).isActive = true
            button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        }
        NSLayoutConstraint.activate([
            undoButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            undoButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            clearButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 40)
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
}
extension SlateViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

