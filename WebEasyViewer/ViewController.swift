//
//  ViewController.swift
//  WebEasyViewer
//
//  Created by benjamin kent on 4/3/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com", "time.gov"]
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        // create a < and > image
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let imageBack = UIImage(systemName: "chevron.left", withConfiguration: config)
        let imageForward = UIImage(systemName: "chevron.right", withConfiguration: config)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(imageBack, for: .normal)
        //backButton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        //backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        let forwardButton = UIButton(type: .custom)
        forwardButton.setImage(imageForward, for: .normal)
        //forwardButton.setTitle(">", for: .normal)
        forwardButton.setTitleColor(forwardButton.tintColor, for: .normal)
        forwardButton.addTarget(self, action: #selector(self.forwardAction(_:)), for: .touchUpInside)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(customView: backButton)
        let forward = UIBarButtonItem(customView: forwardButton)
        
        toolbarItems = [progressButton, spacer, back, spacer, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://\(websites[0])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        //ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        //ac.addAction(UIAlertAction(title: "time.gov", style: .default, handler: openPage))
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    func openPage(action: UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        self.webView.scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    
                    return
                }
            }
            // allows for Inital load of sites and provides alert for invalid navigation attempts.
            validNavigationAttempt(allowedUrl: false)
        }
        decisionHandler(.cancel)
    }
     
    func validNavigationAttempt(allowedUrl: Bool){
        if allowedUrl {
            return
        } else {
            let ac = UIAlertController(title: "Navigation not available", message: "You are attempting to access a url outside the intent of this application.", preferredStyle: .alert )
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        //let _ = self.navigationController?.popViewController(animated: true)
        let ac = UIAlertController(title: "You touched the back button", message: "we're going back", preferredStyle: .alert )
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        // theses don't really do any thing yet
        
    }
    @IBAction func forwardAction(_ sender: UIButton){
        let ac = UIAlertController(title: "You touched the forward button", message: "we're going forward", preferredStyle: .alert )
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        // theses don't really do any thing yet
    }
}

