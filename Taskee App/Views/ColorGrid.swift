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
    
     private let stackView = UIStackView()
    
     private var firstRow = UIStackView()
     private var secondRow = UIStackView()
     private var thirdRow = UIStackView()
    //    var fourthRow = UIStackView()
    
    var delegate: ButtonBackgroundColorDelegate!
    
     private let colorOne = UIButton()
     private let colorTwo = UIButton()
     private let colorThree = UIButton()
     private let colorFour = UIButton()
     private let colorFive = UIButton()
     private let colorSix = UIButton()
     private let colorSeven = UIButton()
     private let colorEight = UIButton()
     private let colorNine = UIButton()
    
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
    
    private func createButtonList() {
        self.buttons = [self.colorOne, self.colorTwo, self.colorThree, self.colorFour,
                        self.colorFive, self.colorSix, self.colorSeven, self.colorEight, self.colorNine
        ]
        
        for button in buttons {
            createBorder(button)
        }
    }
    
    private func configureColumnStackView(){
        addSubview(stackView)
//        clipsToBounds = true
        stackView.addArrangedSubview(firstRow)
        stackView.addArrangedSubview(secondRow)
        stackView.addArrangedSubview(thirdRow)
        //        stackView.addArrangedSubview(fourthRow)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureFirstRow(){
            
        colorOne.backgroundColor = customColor.colorOne.myCustomColor
        colorTwo.backgroundColor = customColor.colorTwo.myCustomColor
        colorThree.backgroundColor = customColor.colorThree.myCustomColor
        
        //        createBorder(oneButton)
        //        createBorder(twoButton)
        //        createBorder(threeButton)
        //
        
        colorOne.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorTwo.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorThree.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        
        firstRow.addArrangedSubview(colorOne)
        firstRow.addArrangedSubview(colorTwo)
        firstRow.addArrangedSubview(colorThree)
        
        configureRowStack(firstRow)
        
        //        firstRow.translatesAutoresizingMaskIntoConstraints = false
        //        firstRow.axis = .horizontal
        //        firstRow.distribution = .fillEqually
        //        firstRow.spacing = 4
        
    }
    
    private func configureSecondRow(){
        
        colorFour.backgroundColor = customColor.colorFour.myCustomColor
        colorFive.backgroundColor = customColor.colorFive.myCustomColor
        colorSix.backgroundColor = customColor.colorSix.myCustomColor
        
        //        createBorder(fourButton)
        //        createBorder(fiveButton)
        //        createBorder(sixButton)
        
        colorFour.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorFive.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorSix.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        
        
        secondRow.addArrangedSubview(colorFour)
        secondRow.addArrangedSubview(colorFive)
        secondRow.addArrangedSubview(colorSix)
        configureRowStack(secondRow)
        //        secondRow.translatesAutoresizingMaskIntoConstraints = false
        //        secondRow.axis = .horizontal
        //        secondRow.distribution = .fillEqually
        //        secondRow.spacing = 4
        
    }
    
    private func configureThirdRow(){
        
        colorSeven.backgroundColor = customColor.colorSeven.myCustomColor
        colorEight.backgroundColor = customColor.colorEight.myCustomColor
        colorNine.backgroundColor = customColor.colorNine.myCustomColor
        //
        //        createBorder(sevenButton)
        //        createBorder(eightButton)
        //        createBorder(nineButton)
        
        colorSeven.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorEight.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        colorNine.addTarget(self, action: #selector(returnButtonValue), for: .touchUpInside)
        
        thirdRow.addArrangedSubview(colorSeven)
        thirdRow.addArrangedSubview(colorEight)
        thirdRow.addArrangedSubview(colorNine)
        
        self.configureRowStack(thirdRow)
        
    }
    
    private func createBorder(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        button.layer.cornerRadius = 30
        
    }
    
    private func configureRowStack(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
//        stack.spacing = 2
    }
    
    @objc func returnButtonValue(_ sender: UIButton ) {
        let color = sender.backgroundColor! as UIColor
        sender.layer.borderColor = UIColor.yellow.cgColor
        self.delegate.getButtonColor(buttonColor: color)
        
        for buttonColor in buttons where buttonColor != sender {
            createBorder(buttonColor)
        }
        
    }
    
    func checkMatchAndHighlight(with color: UIColor) {
        for button in buttons {
            if button.backgroundColor == color {
                button.layer.borderColor = UIColor.yellow.cgColor
            }
        }
    }
}
