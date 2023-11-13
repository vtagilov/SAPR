//
//  StickLocationVC.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit


enum Direction {
    case left
    case right
}



protocol StickLocationDelegate {
    func addStickTo(_ direction: Direction)
    func setParameters(_ stick: UIStick)
}



class StickLocationVC: UIViewController {

    let stick = UIStick()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
    private func configureUI() {
        
        stick.delegate = self
        stick.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: 200)
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 5.0
//        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .red
        
        setConstraints()
        
    }

}



// MARK: - Constraints
extension StickLocationVC {
    private func setConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stick)
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.height),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width * 3),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            stick.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width / 5),
            stick.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.height / 40),
            stick.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stick.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            
        ])
    }
    
    private func addConstraintsToNewStick(from stick: UIStick, to newStick: UIStick, direction: Direction) {
        if direction == .left {
            NSLayoutConstraint.activate([
                newStick.rightAnchor.constraint(equalTo: stick.leftAnchor),
                newStick.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width / 5),
                newStick.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.height / 40),
                newStick.centerYAnchor.constraint(equalTo: stick.centerYAnchor)
            ])
        } else if direction == .right {
            NSLayoutConstraint.activate([
                newStick.leftAnchor.constraint(equalTo: stick.rightAnchor),
                newStick.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width / 5),
                newStick.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.height / 40),
                newStick.centerYAnchor.constraint(equalTo: stick.centerYAnchor)
            ])
        }
    }
    
}



// MARK: - StickLocationDelegate
extension StickLocationVC: StickPrametersDelegate {
    
    func setParameters(_ stick: UIStick) {
        print("dasdasd")
    }
    
    func addStickTo(_ direction: Direction) {
        var stick = stick
        let newStick = UIStick()
        newStick.translatesAutoresizingMaskIntoConstraints = false
        newStick.delegate = self
        
        if direction == .left {
            while stick.leftStick != nil {
                stick = stick.leftStick!
            }
            let newStick = UIStick()
            stick.leftStick = newStick
            
        }
        if direction == .right {
            while stick.rightStick != nil {
                stick = stick.rightStick!
            }
            
            stick.rightStick = newStick
            
        }
        getStickLocationInAlert()
        contentView.addSubview(newStick)
        addConstraintsToNewStick(from: stick, to: newStick, direction: direction)
    }
    
    
    private func getStickLocationInAlert() {
        let alertController = UIAlertController(title: "Введите значения", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "по X"
            textField.keyboardType = .numbersAndPunctuation
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "по Y"
            textField.keyboardType = .numbersAndPunctuation
        }
        
        
        let submitAction = UIAlertAction(title: "Готово", style: .default) { (_) in
            guard let textField1 = alertController.textFields?[0],
                  let textField2 = alertController.textFields?[1],
                  let value1 = textField1.text,
                  let value2 = textField2.text else {
                return
            }
            
            
            print("Значение 1: \(value1)")
            print("Значение 2: \(value2)")
        }
        
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}



// MARK: - UIScrollViewDelegate
//extension StickLocationVC: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return contentView
//    }
//}
