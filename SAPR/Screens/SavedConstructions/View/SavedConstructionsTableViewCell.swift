//
//  SavedConstructionsTableViewCell.swift
//  SAPR
//
//  Created by Владимир on 13.12.2023.
//

import UIKit

protocol SavedConstructionsTableViewCellDelegate {
    func deleteConstruction(construction: Construction)
}

class SavedConstructionsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SavedConstructionsTableViewCell"
    
    var delegate: SavedConstructionsTableViewCellDelegate?
    
    let constructionTitle = UILabel()
    let deleteButton = UIButton()
    let constructionView = ConstructionLoadsView()
    
    var construction: Construction?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(construction: Construction) {
        self.construction = construction
        setConstraints()
        
        constructionTitle.text = construction.name
        constructionTitle.font = .boldSystemFont(ofSize: 32)
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        deleteButton.setTitleColor(.lightGray, for: .highlighted)
        
        constructionView.removeAllRods()
        for _ in 1 ..< construction.rodParametres.count {
            constructionView.addStickTo(.right)
        }
        constructionView.configureSupports(construction.supportParametres)
        for i in 0 ..< construction.focusedLoads.count {
            constructionView.setFocusedLoad(numOfNode: i, power: construction.focusedLoads[i])
        }
        for i in 0 ..< construction.distributedLoads.count {
            constructionView.setDistributedLoad(numOfRod: i, power: construction.distributedLoads[i])
        }
    }
    
    
    @objc private func deleteButtonAction() {
        delegate?.deleteConstruction(construction: construction!)
    }

}


extension SavedConstructionsTableViewCell {
    private func setConstraints() {
        
        for subview in [constructionView, constructionTitle, deleteButton] {
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            constructionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            constructionTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            deleteButton.centerYAnchor.constraint(equalTo: constructionTitle.centerYAnchor),
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            constructionView.topAnchor.constraint(equalTo: constructionTitle.bottomAnchor, constant: 10),
            constructionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            constructionView.heightAnchor.constraint(equalToConstant: 200),
            constructionView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}
