//
//  CalculationModel.swift
//  SAPR
//
//  Created by Владимир on 19.12.2023.
//

import Foundation

class CalculationModel {

    var numsAfterPoint = 3
    
    private var construction: Construction!
    
    private var A = [[Double]]()
    private var b = [Double]()
    private var delta = [Double]()
    private var Nx = [[Double]]()
    
    let aDimension = 0
    
    
    func calculate(_ construction: Construction) {
        self.construction = construction
        calculateA()
        calculateB()
        calculateDelta()
        calculateNx()
    }
    
    func configureText() -> String {
        var text = "Промежуточные значения: \n"
        for lineNum in 0 ..< A.count {
            if lineNum == ( construction.rodParametres.count + 1 ) / 2 {
                text += "A = ["
            } else {
                text += "        ["
            }
            for num in A[lineNum] {
                text += "  \(num.getRounded(numsAfterPoint))  "
            }
            text += "]\n"
        }
        text += "\nb = ["
        for num in b {
            text += "  \(num.getRounded(numsAfterPoint))  "
        }
        
        text += "]\n\n∆ = ["
        for num in delta {
            text += "  \(num.getRounded(numsAfterPoint))  "
        }
        text += "]\n"
        
        for i in 0 ..< Nx.count {
            text += "N\(i)0 = \(Nx[i][0].getRounded(numsAfterPoint))     N\(i)L = \(Nx[i][1].getRounded(numsAfterPoint))"
        }
        
        return text
    }
    
    
    private func calculateA() {
        let aDimension = construction.rodParametres.count + 1
        A = Array(repeating: Array(repeating: 0, count: aDimension), count: aDimension)
        A[0][0] = construction.rodMaterials[construction.rodParametres[0].materialId!].elasticModulus * construction.rodParametres[0].square / construction.rodParametres[0].length
        A[aDimension - 1][aDimension - 1] = construction.rodMaterials[construction.rodParametres[aDimension - 2].materialId!].elasticModulus * construction.rodParametres[aDimension - 2].square / construction.rodParametres[aDimension - 2].length
        for i in 1 ..< aDimension - 1 {
            A[i][i] = ( construction.rodMaterials[construction.rodParametres[i - 1].materialId!].elasticModulus * construction.rodParametres[i - 1].square / construction.rodParametres[i - 1].length ) + ( construction.rodMaterials[construction.rodParametres[i].materialId!].elasticModulus * construction.rodParametres[i].square / construction.rodParametres[i].length )
        }
        for i in 0 ..< aDimension - 1 {
            A[i][i+1] = -1 * construction.rodMaterials[construction.rodParametres[i].materialId!].elasticModulus * construction.rodParametres[i].square / construction.rodParametres[i].length
            A[i+1][i] = A[i][i+1]
        }
        if construction.supportParametres.isLeftFixed {
            A[0][0] = 1
            A[1][0] = 0
            A[0][1] = 0
        }
        if construction.supportParametres.isRightFixed {
            A[aDimension - 1][aDimension - 1] = 1
            A[aDimension - 1][aDimension - 2] = 0
            A[aDimension - 2][aDimension - 1] = 0
        }
    }
    
    private func calculateB() {
        let bDimension = construction.focusedLoads.count
        b = Array(repeating: 0, count: bDimension)
        for i in 0 ..< bDimension {
            if i == 0 {
                if construction.supportParametres.isLeftFixed {
                    b[i] = 0
                } else {
                    b[i] = construction.focusedLoads[i] + ( construction.distributedLoads[i] * construction.rodParametres[i].length / 2 )
                }
            } else if i == bDimension - 1 {
                if construction.supportParametres.isRightFixed {
                    b[i] = 0
                } else {
                    b[i] = construction.focusedLoads[i] + ( construction.distributedLoads[i - 1] * construction.rodParametres[i - 1].length / 2 )
                }
            } else {
                b[i] = construction.focusedLoads[i] + ( construction.distributedLoads[i - 1] * construction.rodParametres[i - 1].length / 2 ) + ( construction.distributedLoads[i] * construction.rodParametres[i].length / 2 )
            }
        }
    }
    
    private func calculateDelta() {
        delta = solveLinearEquation(A: A, b: b) ?? []
    }
    
    private func calculateNx() {
        for i in 0 ..< delta.count - 1 {
            let materialId = construction.rodParametres[i].materialId!
            let E = construction.rodMaterials[materialId].elasticModulus
            let A = construction.rodParametres[i].square
            let L = construction.rodParametres[i].length
            let k = E * A * (delta[i + 1] - delta[i]) / L
            let q = construction.distributedLoads[i]
//            let NX(x) = k + q * L / 2 * (1 - 2 * x / L)
            let N0 = k + q * L / 2
            let NL = k + q * L / 2 * (1 - 2 * L / L)
            Nx.append([N0, NL])
        }
    }
}



//MARK: - Mathematic methods
extension CalculationModel {
    private func solveLinearEquation(A: [[Double]], b: [Double]) -> [Double]? {
        guard A.count > 0, A[0].count > 0, A.count == b.count else {
            return nil
        }
        var augmentedMatrix = A.enumerated().map { row in
            row.element + [b[row.offset]]
        }
        let rowCount = augmentedMatrix.count
        let columnCount = augmentedMatrix[0].count

        for i in 0..<rowCount {
            var maxRowIndex = i
            for j in i+1..<rowCount {
                if abs(augmentedMatrix[j][i]) > abs(augmentedMatrix[maxRowIndex][i]) {
                    maxRowIndex = j
                }
            }
            if maxRowIndex != i {
                augmentedMatrix.swapAt(i, maxRowIndex)
            }
            let pivot = augmentedMatrix[i][i]
            guard pivot != 0 else {
                return nil
            }
            for j in i+1..<rowCount {
                let factor = augmentedMatrix[j][i] / pivot
                for k in i..<columnCount {
                    augmentedMatrix[j][k] -= factor * augmentedMatrix[i][k]
                }
            }
        }
        var solution = [Double](repeating: 0, count: rowCount)
        for i in (0..<rowCount).reversed() {
            let lastIndex = columnCount - 1
            var sum = augmentedMatrix[i][lastIndex]
            for j in i+1..<columnCount-1 {
                sum -= augmentedMatrix[i][j] * solution[j]
            }
            solution[i] = sum / augmentedMatrix[i][i]
        }
        return solution
    }
}
