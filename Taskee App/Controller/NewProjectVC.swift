//
//  NewProjectVC.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class NewProjectVC: UIViewController, ButtonBackgroundColorDelegate {
    func getButtonColor(buttonColor: UIColor) {
        print(buttonColor)
    }
    
    
    let colorGrid = ColorGrid()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addContraints()
        colorGrid.delegate = self
    }
    
    func addContraints() {
        view.addSubview(colorGrid)
        colorGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.colorGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.colorGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
}
