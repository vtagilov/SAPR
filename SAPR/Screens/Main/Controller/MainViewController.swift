//
//  MainViewController.swift
//  SAPR
//
//  Created by Владимир on 06.12.2023.
//

import UIKit

class MainViewController: UIViewController {

    let constuctionSaver = ConstructionSaver()
    
    let titleLabel = UILabel()
    let newConstructionButton = UIButton()
    let loadConstructionButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }

    
    private func configureUI() {
        titleLabel.text = "SAPR IOS"
        titleLabel.font = .boldSystemFont(ofSize: 32)
        newConstructionButton.setTitle("Новая конструкция", for: .normal)
        loadConstructionButton.setTitle("Загрузить конструкцию", for: .normal)
        
        for button in [newConstructionButton, loadConstructionButton] {
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemGray, for: .highlighted)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = .systemFont(ofSize: 32)
        }
        newConstructionButton.addTarget(self, action: #selector(newConstructionButtonWasTapped), for: .touchUpInside)
        loadConstructionButton.addTarget(self, action: #selector(loadConstructionButtonWasTapped), for: .touchUpInside)
    }
    
    
    @objc private func newConstructionButtonWasTapped() {
        self.navigationController?.pushViewController(CustomTabBarController(), animated: true)
    }
    
    @objc private func loadConstructionButtonWasTapped() {
        constuctionSaver.loadConstructions()
        let savedConsctructionsVC = SavedConstructionsViewController()
        savedConsctructionsVC.delegate = self
        self.navigationController?.pushViewController(savedConsctructionsVC, animated: true)
    }
    
}


extension MainViewController: SavedConstructionsViewControllerDelegate {
    func getConstructions() -> [Construction] {
        return constuctionSaver.constructions
    }
    
    func deleteConstruction(construction: Construction) {
        constuctionSaver.deleteConstruction(name: construction.name!)
        constuctionSaver.loadConstructions()
    }
}



extension MainViewController {
    private func setConstraints() {
        
        for subview in [titleLabel, newConstructionButton, loadConstructionButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.rightAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            newConstructionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newConstructionButton.rightAnchor.constraint(equalTo: view.leftAnchor),
            
            loadConstructionButton.topAnchor.constraint(equalTo: newConstructionButton.bottomAnchor, constant: 50),
            loadConstructionButton.rightAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
}
