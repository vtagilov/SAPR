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
    
    let hostingView = CPTGraphHostingView()
    
    var numAfterPoint = 3.0
    
    var b = [Double]()
    var delta = [Double]()
    var A = [[Double]]()
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        addGraph()
    }
    
    
    func calculate(_ construction: Construction) {
        if !construction.rodParametres.allSatisfy({ $0.materialId != nil }) {
            textView.text = "Не все материалы указаны"
            return
        }
        calculationModel.calculate(construction)
        textView.text = calculationModel.configureText()
    }
    
    
    private func configureUI() {
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 24)
    }
    
    private func addGraph() {
        let graph = CPTXYGraph(frame: hostingView.bounds)
        hostingView.hostedGraph = graph
        graph.backgroundColor = UIColor.white.cgColor
        
        let plot = CPTScatterPlot()
        plot.dataSource = self
        graph.add(plot)
        
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: -10, length: 20)
        plotSpace.yRange = CPTPlotRange(location: -10, length: 20)
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
        
        for subview in [textView, hostingView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            hostingView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
}
