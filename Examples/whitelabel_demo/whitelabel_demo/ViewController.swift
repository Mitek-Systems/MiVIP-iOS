//
//  ViewController.swift
//  whitelabel_demo
//

import UIKit
import MiVIPSdk
import MiVIPApi

private class MenuGesture: UITapGestureRecognizer {
    var scope: String?
}

class ViewController: UIViewController {
    
    private var requestIdTextField = UITextField()
    private var documentCallbackTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        var y = 200.0
        addButton(scope: "QR", y: y) // SCAN REQUEST QR CODE
        y+=100
        addButton(scope: "history", y: y) // SHOW REQUESTS HISTORY
        y+=100
        addButton(scope: "account", y: y) // SHOW STORED WALLET DATA (if reuseEnabled is set to true when opening request)
        y+=100
        addRequestTextField(y: y)
        y+=60
        addCallbackTextField(y: y)
        y+=60
        addButton(scope: "request", y: y) // OPEN DIRECTLY REQUEST USING ID
    }
    
    @objc fileprivate func buttonAction(gesture : MenuGesture) {
        guard let scope = gesture.scope else {return}
        
        print(MiVIPHub.version) // get SDK version
        
        let mivip = MiVIPHub()
        mivip.setSoundsDisabled(true) // enable/disable short sound/vibration notification when something happens (e.g. document processing complete)
        mivip.setReusableEnabled(false)
        
        switch scope {
        case "QR":
            mivip.qrCode(vc: self, requestStatusDelegate: self, documentCallbackUrl: documentCallbackTextField.text, selfieCallbackUrl: nil)
        case "history":
            mivip.history(vc: self)
        case "account":
            mivip.account(vc: self)
        case "request":
            guard let idRequest = requestIdTextField.text else {return} // "35cd1bf3-553b-485e-822f-bba55c9b03e3"
            mivip.request(vc: self, miVipRequestId: idRequest, requestStatusDelegate: self, documentCallbackUrl: documentCallbackTextField.text, selfieCallbackUrl: nil)
        default:
            print("Unknown scope")
        }
    }
    
}

// detegate to get SDK notifications for request status and changes
extension ViewController: MiVIPSdk.RequestStatusDelegate {
    
    func status(status: MiVIPApi.RequestStatus?, result: MiVIPApi.RequestResult?, scoreResponse: MiVIPApi.ScoreResponse?) {
        // "RequestStatus = Optional(HooyuApi.RequestStatus.COMPLETED), RequestResult Optional(HooyuApi.RequestResult.PASS)"
        debugPrint( "RequestStatus = \(status), RequestResult \(result), ScoreResponse \(scoreResponse)")
    }
    
}

// UI
extension ViewController {
    private func addButton(scope: String, y: CGFloat) {
        let button = UIView(frame: CGRect(x: 20, y: y, width: self.view.bounds.width-40, height: 60))
        button.backgroundColor = UIColor.lightGray
        
        let action = MenuGesture()
        action.addTarget(self, action: #selector(buttonAction))
        action.scope = scope
        button.addGestureRecognizer(action)
        
        let textLabel = UILabel()
        textLabel.text = scope
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        textLabel.textColor = UIColor.darkText
        textLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width-40, height: 60)
        button.addSubview(textLabel)
        
        self.view.addSubview(button)
    }
    
    private func addRequestTextField(y: CGFloat) {
        requestIdTextField = UITextField(frame: CGRect(x: 20, y: y, width: self.view.bounds.width-40, height: 50))
        requestIdTextField.backgroundColor = UIColor.white
        requestIdTextField.textColor = UIColor.black
        requestIdTextField.textAlignment = .center
        requestIdTextField.attributedPlaceholder = NSAttributedString(string: "request ID to open", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        requestIdTextField.tintColor = UIColor.gray
        self.view.addSubview(requestIdTextField)
    }
    
    private func addCallbackTextField(y: CGFloat) {
        documentCallbackTextField = UITextField(frame: CGRect(x: 20, y: y, width: self.view.bounds.width-40, height: 50))
        documentCallbackTextField.backgroundColor = UIColor.white
        documentCallbackTextField.textColor = UIColor.black
        documentCallbackTextField.textAlignment = .center
        documentCallbackTextField.attributedPlaceholder = NSAttributedString(string: "document callback URL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        documentCallbackTextField.tintColor = UIColor.gray
        self.view.addSubview(documentCallbackTextField)
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


