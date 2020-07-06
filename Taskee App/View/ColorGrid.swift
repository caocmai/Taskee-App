//
//  ColorGrid.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

protocol ReturnButtonNameDelegate {
    func getButtonLabel(buttonName: UIColor)
}


class ColorGrid: UIView {
    
    let stackView = UIStackView()
    
    var firstRow = UIStackView()
    var secondRow = UIStackView()
//    var thirdRow = UIStackView()
//    var fourthRow = UIStackView()
    
    var delegate: ReturnButtonNameDelegate!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView(){
        addSubview(stackView)
        clipsToBounds = true
        stackView.addArrangedSubview(firstRow)
        stackView.addArrangedSubview(secondRow)
//        stackView.addArrangedSubview(thirdRow)
//        stackView.addArrangedSubview(fourthRow)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat(10.0)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureFirstRow(){
        
        let oneButton = UIButton()
        let twoButton = UIButton()
        let threeButton = UIButton()
        
        oneButton.backgroundColor = UIColor.color(red: 123, green: 12, blue: 12)
        twoButton.backgroundColor = UIColor.color(red: 12, green: 123, blue: 12)
        threeButton.backgroundColor = UIColor.color(red: 89, green: 78, blue: 23)
        
        
        oneButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        firstRow.addArrangedSubview(oneButton)
        firstRow.addArrangedSubview(twoButton)
        firstRow.addArrangedSubview(threeButton)
        firstRow.backgroundColor = .red
        firstRow.translatesAutoresizingMaskIntoConstraints = false
        firstRow.axis = .horizontal
        firstRow.distribution = .fillEqually
        
    }
    
    private func configureSecondRow(){
        let fourButton = UIButton()
        let fiveButton = UIButton()
        let sixButton = UIButton()
        
        fourButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        sixButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        
        secondRow.addArrangedSubview(fourButton)
        secondRow.addArrangedSubview(fiveButton)
        secondRow.addArrangedSubview(sixButton)
        
        secondRow.translatesAutoresizingMaskIntoConstraints = false
        secondRow.axis = .horizontal
        secondRow.distribution = .fillEqually
        
    }
    
    @objc func returnButtonValue(_ sender: UIButton ) {
        print(sender.currentTitle!)
        delegate.getButtonLabel(buttonName: sender.backgroundColor!)
    }
}
