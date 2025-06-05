//
//  HooyuWebViewController.swift
//  HooyuWView
//
//  Actial web view implementation
//

import UIKit
import WebKit
import JavaScriptCore

public protocol WVCloseDelegate {
    func willClose()
}

class HooyuWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var hooyuUrl: String!
    var closeDelegate: WVCloseDelegate?
    
    var newWebviewPopupWindow: WKWebView?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        
        // options to be able to use liveness feature
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.allowsPictureInPictureMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:hooyuUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // handles social login - it needs to be opened in a new window
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // if webview tries to open link in a new window - open it in a new webview
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            newWebviewPopupWindow = WKWebView(frame: view.bounds, configuration: configuration)
            newWebviewPopupWindow!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newWebviewPopupWindow!.navigationDelegate = self
            newWebviewPopupWindow!.uiDelegate = self
            view.addSubview(newWebviewPopupWindow!)
            return newWebviewPopupWindow!
        }
        return nil
    }
    
    // handles webview close
    /*! Notifies your app that the DOM window object's close() method completed successfully.
     @param webView The web view invoking the delegate method.
     @discussion Your app should remove the web view from the view hierarchy and update
     the UI as needed, such as by closing the containing browser tab or window.
     */
    func webViewDidClose(_ webView: WKWebView) {
        newWebviewPopupWindow?.removeFromSuperview()
        newWebviewPopupWindow = nil
    }
    
    // listen for redirect and close WV when done
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            if(navigationAction.navigationType == .other) {
                if let redirectedUrl = navigationAction.request.url {
                    if redirectedUrl.absoluteString.contains("virginmoney.com") {
                        closeDelegate?.willClose()
                        decisionHandler(.cancel)
                        self.dismiss(animated: true)
                        return
                    }
                }
            }
            decisionHandler(.allow)
        }
    
}
