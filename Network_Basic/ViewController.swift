//
//  ViewController.swift
//  Network_Basic
//
//  Created by J on 2022/07/27.
//

import UIKit

class ViewController: UIViewController {
    
    var navigationTitleString: String {
        get {
            return "대장님"
        }
        set {
            title = newValue
        }
    }
    
    var backgroundColor: UIColor = .blue
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UserDefaultsHelper.standard.nickname = "고래"
        
        title = UserDefaultsHelper.standard.nickname
        
        UserDefaultsHelper.standard.age = 10
        
    }

    func configureView() {
        navigationTitleString = "재용님"
        backgroundColor = .red
//        title = navigationTitleString
        view.backgroundColor = backgroundColor
    }
    
//    func configureLabel() {
//        <#code#>
//    }

    
    

    
}

