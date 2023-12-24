//
//  ConstructionWithGraphs.swift
//  SAPR
//
//  Created by Владимир on 19.12.2023.
//

import Foundation
import CorePlot


class ConstructionWithGraphs: ConstructionLoadsView {
    
    var hostingNxView = CPTGraphHostingView()
    var pointsNx = [(Double, Double)]()
    var pointsUx = [(Double, Double)]()
    
    
    
    func setNxGraph(_ yPoints: [Double]) {
        hostingNxView = CPTGraphHostingView()
        pointsNx = []
        for i in 0 ..< yPoints.count {
            pointsNx.append((Double(i/2 + i%2), yPoints[i]))
        }
        
        let graph = CPTXYGraph()
        hostingNxView.hostedGraph = graph
        graph.plotAreaFrame?.masksToBorder = false
        graph.paddingLeft = 0.0
        graph.paddingRight = 0.0
        graph.paddingTop = 0.0
        graph.paddingBottom = 0.0
        let plot = CPTScatterPlot()
        plot.dataSource = self
        graph.add(plot)
        
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: 0, length: stickCount as NSNumber)
        let minY = min(yPoints.min()!, 0) - 0.25
        let maxY = yPoints.max()! - min(yPoints.min()!, 0) + 0.5
        print(yPoints.min()!, yPoints.max()!, minY, maxY)
        plotSpace.yRange = CPTPlotRange(location: minY as NSNumber , length: abs(minY) + maxY as NSNumber)
        plotSpace.delegate = self
        
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        hostingNxView.hostedGraph?.setNeedsDisplay()
        
        if let y = axisSet.yAxis {
            y.labelingPolicy = CPTAxisLabelingPolicy.locationsProvided
            var set: Set<NSNumber> = []
            pointsNx.forEach { set.insert($0.1 as NSNumber) }
            set.insert(0)
            y.majorTickLocations = set
            y.title = "Nx"
            y.titleRotation = 0
        }
        if let x = axisSet.xAxis {
            x.majorIntervalLength = NSNumber(value: 1.0)
            x.minorTicksPerInterval = 0
            x.orthogonalPosition = 0.0
            x.labelingPolicy = .none
        }
        setGraphConstraints()
    }
    
    
    func setConstruction(_ construction: Construction) {
        removeAllRods()
        for _ in 1 ..< construction.rodParametres.count {
            addStickTo(.right)
        }
        configureSupports(construction.supportParametres)
        for i in 0 ..< construction.focusedLoads.count {
            setFocusedLoad(numOfNode: i, power: construction.focusedLoads[i])
        }
        for i in 0 ..< construction.distributedLoads.count {
            setDistributedLoad(numOfRod: i, power: construction.distributedLoads[i])
        }
    }
    
    
}



// MARK: - CPTPlotDataSource
extension ConstructionWithGraphs: CPTPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(pointsNx.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        return (fieldEnum == UInt(CPTScatterPlotField.X.rawValue)) ? pointsNx[Int(idx)].0 : pointsNx[Int(idx)].1
    }
    
    
    
    
}

extension ConstructionWithGraphs: CPTPlotSpaceDelegate {
    func plotSpace(_ space: CPTPlotSpace, willChangePlotRangeTo newRange: CPTPlotRange, for coordinate: CPTCoordinate) -> CPTPlotRange? {
        return CPTPlotRange(location: NSNumber(value: 0.0), length: NSNumber(value: 0.0))
    }
}



extension ConstructionWithGraphs {
//    func findParabolaCoefficients(point1: (Double, Double), point2: (Double, Double), vertexDirectionDown: Bool) -> (Double, Double, Double)? {
//        guard point1.0 != point2.0 else {
//            return nil
//        }
//
//        let h = point1.0
//        let k = point1.1
//
//        let a: Double
//        let b: Double
//
//        let sign: Double = vertexDirectionDown ? -1.0 : 1.0
//
//        if let solution = solveSystem(point1: point1, point2: point2, vertexDirectionDown: vertexDirectionDown) {
//            a = solution.0
//            b = solution.1
//        } else {
//            return nil
//        }
//
//        return (k, b, a)
//    }

    func solveSystem(point1: (Double, Double), point2: (Double, Double), vertexDirectionDown: Bool) -> (Double, Double)? {
        
        let x1 = point1.0
        let y1 = point1.1
        let x2 = point2.0
        let y2 = point2.1

        let sign: Double = vertexDirectionDown ? -1.0 : 1.0

        let determinant = x1 * x1 - x1 * x2 + x2 * x2
        let a = sign * ((y1 - y2) * x2 - (y1 - sign * y2) * x1) / determinant
        let b = sign * ((y1 - sign * y2) * x2 * x2 - (y1 - y2) * x1 * x1) / determinant

        return (a, b)
    }
}


// MARK: - Constraints
extension ConstructionWithGraphs {
    private func setGraphConstraints() {
        
        for subview in [hostingNxView] {
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.deactivate(standartConstraints)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 5000),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            stick.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            stick.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            stick.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            stick.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            leftSupport.rightAnchor.constraint(equalTo: stick.leftAnchor, constant: 6),
            leftSupport.centerYAnchor.constraint(equalTo: stick.centerYAnchor),
            leftSupport.heightAnchor.constraint(equalToConstant: 45),
            
            hostingNxView.topAnchor.constraint(equalTo: stick.bottomAnchor, constant: 25),
            hostingNxView.heightAnchor.constraint(equalToConstant: 100),
            hostingNxView.leftAnchor.constraint(equalTo: stick.leftAnchor),
            hostingNxView.rightAnchor.constraint(equalTo: getStick(num: stickCount - 1)!.rightAnchor)
        ])
    }
    
}


