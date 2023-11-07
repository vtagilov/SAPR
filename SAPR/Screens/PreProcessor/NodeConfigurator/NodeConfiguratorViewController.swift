//
//  NodeConfiguratorViewController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class NodeConfiguratorViewController: UIViewController {

    let constructionView = ConstructionView()
    
    let stickPickerView = UIPickerView()
    let stickConnectionsTableView = UITableView()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Узлы"
        configureUI()
        setConstraints()
        
    }
    

    private func configureUI() {
        
        constructionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stickPickerView.delegate = self
        stickPickerView.dataSource = self
        stickPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        stickConnectionsTableView.estimatedRowHeight = 200
        stickConnectionsTableView.register(StickParametersTableViewCell.self, forCellReuseIdentifier: StickParametersTableViewCell.identifier)
        stickConnectionsTableView.dataSource = self
        stickConnectionsTableView.delegate = self
        stickConnectionsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

}



// MARK: - Constraints
extension NodeConfiguratorViewController {
    private func setConstraints() {
        
        view.addSubview(constructionView)
        view.addSubview(stickPickerView)
        view.addSubview(stickConnectionsTableView)
        
        NSLayoutConstraint.activate([
            
            constructionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constructionView.heightAnchor.constraint(equalToConstant: 250),
            constructionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        
            stickPickerView.topAnchor.constraint(equalTo: constructionView.bottomAnchor),
            stickPickerView.heightAnchor.constraint(equalToConstant: 150),
            stickPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickPickerView.widthAnchor.constraint(equalToConstant: 150),
            
            stickConnectionsTableView.topAnchor.constraint(equalTo: stickPickerView.bottomAnchor),
            stickConnectionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stickConnectionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stickConnectionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}



// MARK: - UIPickerView Extensions
extension NodeConfiguratorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = row + 1
        self.stickConnectionsTableView.reloadData()
    }
}



// MARK: - UITableView Extensions
extension NodeConfiguratorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickPickerView.selectedRow(inComponent: 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickParametersTableViewCell.identifier, for: indexPath) as? StickParametersTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(indexPath.row + 1, stickPickerView.selectedRow(inComponent: 0))
        return cell
    }
    
}
