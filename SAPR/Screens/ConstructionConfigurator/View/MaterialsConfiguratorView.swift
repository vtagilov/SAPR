//
//  AddMaterialVC.swift
//  SAPR
//
//  Created by Владимир on 22.11.2023.
//

import UIKit

protocol MaterialConfiguratorDelegate {
    func setMaterials(materials: [RodMaterial])
    func showErrorAlert(message: String)
}


class MaterialsConfiguratorView: UIView {

    var delegate: MaterialConfiguratorDelegate?
    
    var materials = [RodMaterial]() {
        didSet {
            delegate?.setMaterials(materials: materials)
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView()
    let titleLabel = UILabel()
    let createButton = UIButton()
    
    var standartConstraints = [NSLayoutConstraint]()
    var tableViewConstraints = [NSLayoutConstraint]()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        setConstraints()
    }
    
    init(delegate: MaterialConfiguratorDelegate, materials: [RodMaterial]) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.materials = materials
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MaterialCell.self, forCellReuseIdentifier: MaterialCell.reuseIdentifier)
        
        titleLabel.text = "Материалы"
        titleLabel.font = .systemFont(ofSize: 24)
        createButton.setTitle("Добавить", for: .normal)
        createButton.setTitleColor(.systemBlue, for: .normal)
        createButton.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
    }
    
    
    @objc private func createButtonAction() {
        materials.append(RodMaterial(elasticModulus: 1.0, permissibleVoltage: 1.0))
        delegate?.setMaterials(materials: materials)
    }
    
    


}


extension MaterialsConfiguratorView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MaterialCell.reuseIdentifier, for: indexPath) as? MaterialCell else {
            return UITableViewCell()
        }
        if indexPath.row >= materials.count {
            return cell
        }
        cell.configureCell(delegate: self, id: indexPath.row, material: materials[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath)
        return indexPath
    }
    
}



extension MaterialsConfiguratorView: MaterialCellDelegate {
    func endTyping() {
        
//        tableView.isScrollEnabled = true
//        NSLayoutConstraint.deactivate(tableViewConstraints)
//        NSLayoutConstraint.activate(standartConstraints)
    }
    
    func startTyping(index: Int) {
        print("startTyping at index", index)
        
//        NSLayoutConstraint.deactivate(standartConstraints)
//        NSLayoutConstraint.activate(tableViewConstraints)
        
//        tableView.isScrollEnabled = false
//        tableView.contentOffset = CGPoint(x: 0, y: 200)
//        tableView.scrollToRow(at: IndexPath(row: index - 1, section: 0), at: .top, animated: true)
        
    }
    
    
    func updateMaterial(id: Int, material: RodMaterial) {
        materials[id] = material
    }
    
    func showErrorAlert(message: String) {
        delegate?.showErrorAlert(message: message)
    }
    
}



extension MaterialsConfiguratorView {
    private func setConstraints() {
        
        for subview in [tableView, createButton, titleLabel] {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        standartConstraints = [
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 120),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.rightAnchor.constraint(equalTo: createButton.leftAnchor),
            
            createButton.rightAnchor.constraint(equalTo: rightAnchor),
            createButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
        ])
        NSLayoutConstraint.activate(standartConstraints)
        
    }
    
    
    
}



