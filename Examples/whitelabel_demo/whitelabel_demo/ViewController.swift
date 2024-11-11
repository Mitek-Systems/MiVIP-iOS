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
    private var requestCodeTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        var y = 100.0
        addCallbackTextField(y: y)
        y+=70
        addButton(scope: "QR", y: y) // SCAN REQUEST QR CODE
        y+=65
        addRequestTextField(y: y)
        y+=50
        addButton(scope: "request", y: y) // OPEN DIRECTLY REQUEST USING ID
        y+=65
        addRequestCodeTextField(y: y)
        y+=50
        addButton(scope: "code", y: y) // OPEN REQUEST ID USING 4 DIGIT CODE
        y+=65
        addButton(scope: "history", y: y) // SHOW REQUESTS HISTORY
        y+=65
        addButton(scope: "account", y: y) // SHOW STORED WALLET DATA (if reuseEnabled is set to true when opening request)
    }
    
    @objc fileprivate func buttonAction(gesture : MenuGesture) {
        guard let scope = gesture.scope else {return}
        
        print(MiVIPHub.version) // get SDK version
        
        do {
            let mivip = try MiVIPHub()
            mivip.setSoundsDisabled(true) // enable/disable short sound/vibration notification when something happens (e.g. document processing complete)
            mivip.setReusableEnabled(false) // enable/disable wallet functionality
            mivip.setLogDisabled(false) // if to send SDK failures to MiVIP server for logging. No PII is logged!
            
            // Set custom fonts:
            // 1. Import your font into the project
            // 2. Add new key "Fonts provided by application" on application's info.plist file and add your font names
            // 3. Set MiVIP SDK font names. If given font not set MiVIP will use system font
            mivip.setFontNameUltraLight(fontName: "WorkSans-ExtraLight")
            mivip.setFontNameLight(fontName: "WorkSans-Light")
            mivip.setFontNameThin(fontName: "WorkSans-Thin")
            mivip.setFontNameBlack(fontName: "WorkSans-Black")
            mivip.setFontNameMedium(fontName: "WorkSans-Medium")
            mivip.setFontNameRegular(fontName: "WorkSans-Regular")
            mivip.setFontNameSemiBold(fontName: "WorkSans-SemiBold")
            mivip.setFontNameBold(fontName: "WorkSans-Bold")
            mivip.setFontNamHeavy(fontName: "WorkSans-ExtraBold")
            
            switch scope {
            case "QR":
                mivip.qrCode(vc: self, requestStatusDelegate: self, documentCallbackUrl: documentCallbackTextField.text)
            case "history":
                mivip.history(vc: self)
            case "account":
                mivip.account(vc: self)
            case "request":
                guard let idRequest = requestIdTextField.text else {return} // "35cd1bf3-553b-485e-822f-bba55c9b03e3"
                mivip.request(vc: self, miVipRequestId: idRequest, requestStatusDelegate: self, documentCallbackUrl: documentCallbackTextField.text)
            case "code":
                guard let code = requestCodeTextField.text else {return}
                mivip.getRequestIdFromCode(code: code) { (idRequest, error) in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {return}
                        if let idRequest = idRequest {
                            mivip.request(vc: strongSelf, miVipRequestId: idRequest, requestStatusDelegate: strongSelf, documentCallbackUrl: strongSelf.documentCallbackTextField.text)
                        }
                        if let error = error {
                            debugPrint("Error = \(error)" )
                        }
                    }
                }
            default:
                print("Unknown scope")
            }
            
        } catch let error as MiVIPHub.LicenseError {
            print(error.rawValue)
        } catch {
            print(error)
        }
    }
    
}

// detegate to get SDK notifications for request status and changes
extension ViewController: MiVIPSdk.RequestStatusDelegate {
    
    func status(status: MiVIPApi.RequestStatus?, result: MiVIPApi.RequestResult?, scoreResponse: MiVIPApi.ScoreResponse?, request: MiVIPApi.MiVIPRequest?) {
        // "RequestStatus = Optional(HooyuApi.RequestStatus.COMPLETED), RequestResult Optional(HooyuApi.RequestResult.PASS)"
        debugPrint("MiVIP: RequestStatus = \(status), RequestResult \(result), ScoreResponse \(scoreResponse), MiVIPRequest \(request)")
    }
    
    func error(err: String) {
        debugPrint("MiVIP: \(err)")
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
    
    private func addRequestCodeTextField(y: CGFloat) {
        requestCodeTextField = UITextField(frame: CGRect(x: 20, y: y, width: self.view.bounds.width-40, height: 50))
        requestCodeTextField.backgroundColor = UIColor.white
        requestCodeTextField.textColor = UIColor.black
        requestCodeTextField.textAlignment = .center
        requestCodeTextField.keyboardType = .numberPad
        requestCodeTextField.attributedPlaceholder = NSAttributedString(string: "4 digit request code", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        requestCodeTextField.tintColor = UIColor.gray
        self.view.addSubview(requestCodeTextField)
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


