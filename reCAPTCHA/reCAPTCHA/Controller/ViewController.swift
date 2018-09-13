//
//  ViewController.swift
//  reCAPTCHA
//
//  Created by ac on 13/09/2018.
//  Copyright © 2018 cewpur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let promptButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Prompt", for: UIControlState())
        button.addTarget(self, action: #selector(promptCaptchaController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "reCAPTCHA iOS"
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(promptButton)
        
        promptButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        promptButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        promptButton.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    @objc fileprivate func promptCaptchaController() {
        guard let url = URL(string: "URL_OF_PAGE_WITH_RECAPTCHA") else {
            return
        }
        
        let siteKey = "SITE_KEY"
        let recaptchaController = RecaptchaController(siteKey: siteKey, url: url, backgroundColor: .darkGray, captchaTheme: .dark) { (response) in
            print(response)
        }
        
        recaptchaController.didLoad = {
            print("Captcha loaded")
        }
        
        recaptchaController.didExpire = {
            print("Captcha expired")
        }
        
        let navController = UINavigationController(rootViewController: recaptchaController)
        self.present(navController, animated: true, completion: nil)
    }
}

