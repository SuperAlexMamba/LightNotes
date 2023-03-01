//
//  MenuView.swift
//  NotesApp
//
//  Created by Слава Орлов on 09.02.2023.
//

import Foundation
import UIKit

public var menuView: UIView = {
     let width = UIScreen.main.bounds.width / 2
     
     let positionY = 0.0
     let positionX = 0.0 - width
     let height = UIScreen.main.bounds.height
     
     let menuView = UIView(frame: CGRect(x: positionX , y: positionY, width: width , height: height))
    menuView.backgroundColor = .white
    menuView.addSubview(settingsButtonInMenu)
    menuView.addSubview(aboutAppButtonInMenu)
    menuView.addSubview(labelInfo)

     return menuView
 }()

public var backgroundAlpha: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    view.alpha = 0.4
    view.backgroundColor = .black
    
    return view
}()

public var settingsButtonInMenu: UIButton = {
    let button = UIButton()
    button.setTitle("Настройки", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.5716881752, green: 0.5385032296, blue: 1, alpha: 1)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    return button
}()

public var aboutAppButtonInMenu: UIButton = {
    let button = UIButton()
    button.setTitle("тут будет info", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.5716881752, green: 0.5385032296, blue: 1, alpha: 1)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    button.isEnabled = false
    button.isSelected = false
    
    return button
}()

public var labelInfo: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 13)
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    label.text = "Версия \(String(describing: appVersion)) \nBy Vyacheslav Orlov"
    label.textColor = .gray
    label.numberOfLines = 2
    label.textAlignment = .center
    label.alpha = 0.8
    
    return label
}()



public func setupConstraintsInMenuView() {
    let safeArea = menuView.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
        
        settingsButtonInMenu.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20),
        settingsButtonInMenu.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20),
        settingsButtonInMenu.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 35),
        settingsButtonInMenu.heightAnchor.constraint(equalToConstant: 35),
        
        aboutAppButtonInMenu.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20),
        aboutAppButtonInMenu.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20),
        aboutAppButtonInMenu.topAnchor.constraint(equalTo: settingsButtonInMenu.bottomAnchor, constant: 18),
        aboutAppButtonInMenu.heightAnchor.constraint(equalToConstant: 35),
                
        labelInfo.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),
        labelInfo.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20),
        labelInfo.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20),
        labelInfo.heightAnchor.constraint(equalToConstant: 50)
    ])
}
