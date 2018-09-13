//
//  RecaptchaController.swift
//  reCAPTCHA
//
//  Created by ac on 13/09/2018.
//  Copyright © 2018 cewpur. All rights reserved.
//

import UIKit
import WebKit

public class RecaptchaController: UIViewController, WKScriptMessageHandler {
    
    private let didSolve: (String) -> ()
    private var webView: WKWebView!
    
    public var didLoad: (() -> ())? = nil
    public var didExpire: (() -> ())? = nil
    
    init(siteKey: String, url: URL, backgroundColor: UIColor, captchaTheme: CaptchaTheme, didSolve: @escaping (String) -> ()) {
        self.didSolve = didSolve
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = backgroundColor
        self.navigationItem.title = "Captcha"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissController))
        
        let contentController = WKUserContentController()
        let webConfig = WKWebViewConfiguration()
        
        contentController.add(self, name: "recaptchaios")
        contentController.addUserScript(readCaptchaScript(siteKey: siteKey, recaptchaTheme: captchaTheme.rawValue,
                                                          backgroundColorCSS: UIColorAsHex(color: backgroundColor)))
        
        webConfig.userContentController = contentController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: webConfig)
        self.webView.load(URLRequest(url: url))
    }
    
    @objc fileprivate func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let args = message.body as? [String] else {
            return
        }
        
        switch args[0] {
        case "didLoad":
            self.view.addSubview(self.webView)
            
            if let didLoad = self.didLoad {
                didLoad()
            }
            
            break
        case "didSolve":
            self.didSolve(args[1])
            self.dismissController()
            
            break
        case "didExpire":
            if let didExpire = self.didExpire {
                didExpire()
            }
            
            break
        default:
            return
        }
    }
    
    fileprivate func readCaptchaScript(siteKey: String, recaptchaTheme: String, backgroundColorCSS: String) -> WKUserScript {
        guard let filePath = Bundle.main.path(forResource: "script", ofType: "js") else {
            fatalError("Fatal error: script.js absent from bundle")
        }
        
        do {
            let parsed = try String(contentsOfFile: filePath)
            let source = String(format: parsed, siteKey, recaptchaTheme, backgroundColorCSS) // interpolate Swift-side settings

            return WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        } catch let error {
            return WKUserScript(source: "alert(\(error.localizedDescription);", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        }
    }
    
    fileprivate func UIColorAsHex(color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba = [r, g, b, a].map { $0 * 255 }.reduce("", { $0 + String(format: "%02x", Int($1)) })
        
        return "#\(rgba)"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
