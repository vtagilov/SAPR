//
//  SavedConstructionsViewController.swift
//  SAPR
//
//  Created by Владимир on 06.12.2023.
//

import UIKit

protocol SavedConstructionsViewControllerDelegate {
    func deleteConstruction(construction: Construction)
    func getConstructions() -> [Construction]
}


class SavedConstructionsViewController: UIViewController {
    
    var delegate: SavedConstructionsViewControllerDelegate?

    var constructions = [Construction]()
    
    let titleLabel = UILabel()
    let tableView = UITableView()
    let emptyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedConstructionsTableViewCell.self, forCellReuseIdentifier: SavedConstructionsTableViewCell.reuseIdentifier)
        
        emptyLabel.text = "Конструкции отсутствуют"
        emptyLabel.isHidden = true
    }
    

    private func showConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Удаление конструкции", message: "Вы уверены, что хотите удалить эту конструкцию", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            completion(true)
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            completion(false)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
}

extension SavedConstructionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constructions = delegate!.getConstructions()
        emptyLabel.isHidden = !(constructions.count == 0)
        return constructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedConstructionsTableViewCell.reuseIdentifier, for: indexPath) as? SavedConstructionsTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(construction: constructions[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension SavedConstructionsViewController: SavedConstructionsTableViewCellDelegate {
    func deleteConstruction(construction: Construction) {
        showConfirmationAlert() { willDelete in
            if willDelete {
                self.delegate?.deleteConstruction(construction: construction)
                self.tableView.reloadData()
            }
        }
    }
}


extension SavedConstructionsViewController {
    private func setConstraints() {
        
        for subview in [tableView, emptyLabel] {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
