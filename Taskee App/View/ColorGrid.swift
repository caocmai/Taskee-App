//
//  ColorGrid.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

protocol ButtonBackgroundColorDelegate {
    func getButtonColor(buttonColor: UIColor)
}


class ColorGrid: UIView {
    
    let stackView = UIStackView()
    
    var firstRow = UIStackView()
    var secondRow = UIStackView()
    var thirdRow = UIStackView()
    //    var fourthRow = UIStackView()
    
    var delegate: ButtonBackgroundColorDelegate!
    
    let oneButton = UIButton()
    let twoButton = UIButton()
    let threeButton = UIButton()
    let fourButton = UIButton()
    let fiveButton = UIButton()
    let sixButton = UIButton()
    let sevenButton = UIButton()
    let eightButton = UIButton()
    let nineButton = UIButton()
    
    var buttons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
        createButtonList()
        configureFirstRow()
        configureSecondRow()
        configureThirdRow()
        configureColumnStackView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func createButtonList() {
        self.buttons = [self.oneButton, self.twoButton, self.threeButton, self.fourButton,
                        self.fiveButton, self.sixButton, self.sevenButton, self.eightButton, self.nineButton
        ]
        
        for button in buttons {
            createBorder(button)
        }
    }
    
    internal func configureColumnStackView(){
        addSubview(stackView)
        clipsToBounds = true
        stackView.addArrangedSubview(firstRow)
        stackView.addArrangedSubview(secondRow)
        stackView.addArrangedSubview(thirdRow)
        //        stackView.addArrangedSubview(fourthRow)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat(4.0)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    internal func configureFirstRow(){
        
        oneButton.backgroundColor = UIColor.color(red: 123, green: 12, blue: 12)
        twoButton.backgroundColor = UIColor.color(red: 12, green: 123, blue: 12)
        threeButton.backgroundColor = UIColor.color(red: 89, green: 78, blue: 23)
        
        //        createBorder(oneButton)
        //        createBorder(twoButton)
        //        createBorder(threeButton)
        //
        
        oneButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        firstRow.addArrangedSubview(oneButton)
        firstRow.addArrangedSubview(twoButton)
        firstRow.addArrangedSubview(threeButton)
        
        configureRowStack(firstRow)
        
        //        firstRow.translatesAutoresizingMaskIntoConstraints = false
        //        firstRow.axis = .horizontal
        //        firstRow.distribution = .fillEqually
        //        firstRow.spacing = 4
        
    }
    
    internal func configureSecondRow(){
        
        fourButton.backgroundColor = customColor.myGreen.myCustomColor
        fiveButton.backgroundColor = customColor.myYellow.myCustomColor
        sixButton.backgroundColor = UIColor.color(red: 89, green: 78, blue: 23)
        
        //        createBorder(fourButton)
        //        createBorder(fiveButton)
        //        createBorder(sixButton)
        
        fourButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        sixButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        
        
        secondRow.addArrangedSubview(fourButton)
        secondRow.addArrangedSubview(fiveButton)
        secondRow.addArrangedSubview(sixButton)
        configureRowStack(secondRow)
        //        secondRow.translatesAutoresizingMaskIntoConstraints = false
        //        secondRow.axis = .horizontal
        //        secondRow.distribution = .fillEqually
        //        secondRow.spacing = 4
        
    }
    
    internal func configureThirdRow(){
        
        sevenButton.backgroundColor = UIColor.color(red: 123, green: 12, blue: 12)
        eightButton.backgroundColor = UIColor.color(red: 12, green: 123, blue: 12)
        nineButton.backgroundColor = UIColor.color(red: 89, green: 78, blue: 23)
        //
        //        createBorder(sevenButton)
        //        createBorder(eightButton)
        //        createBorder(nineButton)
        
        sevenButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        eightButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        nineButton.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        thirdRow.addArrangedSubview(sevenButton)
        thirdRow.addArrangedSubview(eightButton)
        thirdRow.addArrangedSubview(nineButton)
        
        self.configureRowStack(thirdRow)
        
    }
    
    internal func createBorder(_ button: UIButton) {
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    internal func configureRowStack(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 4
    }
    
    @objc func returnButtonValue(_ sender: UIButton ) {
        let color = sender.backgroundColor! as UIColor
        sender.layer.borderColor = UIColor.yellow.cgColor
        self.delegate.getButtonColor(buttonColor: color)
        
        for buttonColor in buttons where buttonColor != sender {
            createBorder(buttonColor)
        }
        
    }
}
