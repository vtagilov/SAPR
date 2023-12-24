//
//  CalculationViewController.swift
//  SAPR
//
//  Created by Владимир on 14.12.2023.
//

import UIKit
import CorePlot

class CalculationViewController: UIViewController {

    let calculationModel = CalculationModel()
    let constructionView = ConstructionWithGraphs()
    
    let calculationLabel = UILabel()
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    
    func calculate(_ construction: Construction) {
        if !construction.rodParametres.allSatisfy({ $0.materialId != nil }) {
            textView.text = "Не все материалы указаны"
            return
        }
        calculationModel.calculate(construction)
        textView.text = calculationModel.configureText()
        constructionView.setConstruction(construction)
        constructionView.setNxGraph(calculationModel.getPointNx())
    }
    
    
    private func configureUI() {
        calculationLabel.text = "Промежуточные значения:"
        calculationLabel.font = .systemFont(ofSize: 24)
        
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
    }
    
}


extension CalculationViewController: CPTPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 100
    }

    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let x = Double(idx) - 50.0
        let y = yourEquation(x)
        return (fieldEnum == UInt(CPTScatterPlotField.X.rawValue)) ? x : y
    }

    func yourEquation(_ x: Double) -> Double {
        return 5*x + 15
    }
}


extension CalculationViewController {
    private func setConstraints() {
        
        for subview in [textView, constructionView, calculationLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            calculationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            calculationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            calculationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: calculationLabel.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: constructionView.topAnchor, constant: -10),
            
            constructionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            constructionView.heightAnchor.constraint(equalToConstant: 250),
            constructionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
}
