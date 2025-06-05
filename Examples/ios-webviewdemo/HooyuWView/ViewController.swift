//
//  ViewController.swift
//  HooyuWView
//
//  Main screen UI
//

import UIKit

class ViewController: UIViewController {
    
    static let orange = UIColor(red: 0x0C / 255.0, green: 0x51 / 255.0, blue: 0x60 / 255.0, alpha: 1.00) // 0C5160
    static let lightOrange = UIColor(red: 0x0B / 255.0, green: 0x1B / 255.0, blue: 0x2B / 255.0, alpha: 1.00) // 0B1B2B
    static let grayBackground = UIColor(red: 0xF5 / 255.0, green: 0xF5 / 255.0, blue: 0xF5 / 255.0, alpha: 1.00)
    
    static let virgin = UIColor(red: 0xE0 / 255.0, green: 0x0C / 255.0, blue: 0x0B / 255.0, alpha: 1.00) // E00C0B
    
    let urlField = UITextView()
    
    var virginView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ViewController.grayBackground
        
        hideKeyboardWhenTappedAround()
        
        // UI add header
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        // Add header
        let headerHeight:CGFloat = 150
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight))
        // logo
        let logoWhite = UIImageView()
        let image =  UIImage(named: "logo_white")!
        logoWhite.image = image
        let imageH = headerHeight/3.6
        let imageY = (headerHeight-imageH)/2
        let desiredImageViewWidth = (imageH / image.size.height) * image.size.width
        logoWhite.frame = CGRect(x: 20, y: imageY, width: desiredImageViewWidth , height: imageH)
        logoWhite.contentMode = .scaleAspectFit
        header.addSubview(logoWhite)
        // text
        let textLabel = UILabel()
        textLabel.text = "MiVIP webview demo"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
        textLabel.textColor = UIColor.white
        let textY = imageY + imageH + 1
        textLabel.frame = CGRect(x: 25, y: textY, width: screenWidth-60, height: headerHeight/3)
        header.addSubview(textLabel)
        
        header.setGradientBackground(colorOne: ViewController.lightOrange, colorTwo: ViewController.orange)
        self.view.addSubview(header)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 150, width: screenWidth, height: screenHeight-150))
        self.view.addSubview(scrollView)
        
        var y:CGFloat = 0
        
        // input to paste request URL
        let urlLabel = UILabel()
        urlLabel.text = "MiVIP request URL:"
        urlLabel.textAlignment = .left
        urlLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        urlLabel.adjustsFontSizeToFitWidth = true
        urlLabel.minimumScaleFactor = 0.2
        urlLabel.textColor = ViewController.orange
        urlLabel.frame = CGRect(x: 30, y: y+40, width: screenWidth-60, height: 30)
        scrollView.addSubview(urlLabel)
        y = y + 80
        
        urlField.frame =  CGRect(x: 10, y: y, width: screenWidth-20, height: 80)
        urlField.textAlignment = .center
        urlField.layer.borderWidth = 2
        urlField.layer.borderColor = ViewController.orange.cgColor
        urlField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        urlField.textColor = UIColor.darkGray
        urlField.backgroundColor = UIColor.white
        urlField.layer.cornerRadius = 6.0
        urlField.keyboardType = .URL
        scrollView.addSubview(urlField)
        y = y + 70
        
        let goButton = addButton(btnY: y, text: "GO", inverted: false)
        let goAction = UITapGestureRecognizer()
        goAction.addTarget(self, action: #selector(openUrl))
        goButton.addGestureRecognizer(goAction)
        scrollView.addSubview(goButton)
        y = y + 120
        
        // button to scan QR code
        let qrLabel = UILabel()
        qrLabel.text = "Or scan MiVIP request QR code"
        qrLabel.textAlignment = .left
        qrLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        qrLabel.adjustsFontSizeToFitWidth = true
        qrLabel.minimumScaleFactor = 0.2
        qrLabel.textColor = ViewController.orange
        qrLabel.frame = CGRect(x: 30, y: y+40, width: screenWidth-60, height: 30)
        scrollView.addSubview(qrLabel)
        y = y + 50
        
        let scanQrButton = addButton(btnY: y, text: "Scan QR code", inverted: true)
        let action = UITapGestureRecognizer()
        action.addTarget(self, action: #selector(scanQrCode))
        scanQrButton.addGestureRecognizer(action)
        scrollView.addSubview(scanQrButton)
        y = y + 80
        
//        let virginButton = addButton(btnY: y, text: "Virgin Money", inverted: true)
//        let vaction = UITapGestureRecognizer()
//        vaction.addTarget(self, action: #selector(virginAction))
//        virginButton.addGestureRecognizer(vaction)
//        scrollView.addSubview(virginButton)
//        y = y + 80
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: y)
    }
    
    @objc func scanQrCode(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let item = storyboard.instantiateViewController(withIdentifier: "QRScanViewController") as? QRScanViewController else {return}
        item.modalPresentationStyle = .fullScreen
        item.modalTransitionStyle = .crossDissolve
        self.present(item, animated: true, completion: nil)
    }
    
    @objc func virginAction(gesture: UITapGestureRecognizer) {
        virginView.removeFromSuperview()
        virginView = UIView(frame: view.frame)
        virginView.backgroundColor = UIColor.white
        
        var y:CGFloat = 60
        
        // add logo
        let logoWhite = UIImageView()
        let image = UIImage(named: "virgin_logo")!
        logoWhite.image = image
        let imageW = view.frame.width * 2/3
        let desiredImageViewH = (imageW / image.size.width) * image.size.height
        logoWhite.frame = CGRect(x: (view.frame.width - imageW)/2, y: y, width: imageW , height: desiredImageViewH)
        logoWhite.contentMode = .scaleAspectFit
        virginView.addSubview(logoWhite)
        y = y + desiredImageViewH + 20
        
        // add text
        let txtLabel = UILabel()
        txtLabel.text = "You have opted to authorise payments with your trusted biometrics. Please capture a selfie to proceed"
        txtLabel.textAlignment = .left
        txtLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        txtLabel.numberOfLines = 0
        txtLabel.textColor = UIColor.gray
        txtLabel.frame = CGRect(x: 20, y: y, width: view.frame.width-40, height: 80)
        virginView.addSubview(txtLabel)
        y = y + 100
        
        // add image
        let mipassImage = UIImageView()
        let mipass = UIImage(named: "mipass")!
        mipassImage.image = mipass
        let mpimageW = view.frame.width * 2/3
        let mpdesiredImageViewH = (imageW / mipass.size.width) * mipass.size.height
        mipassImage.frame = CGRect(x: (view.frame.width - imageW)/2, y: y, width: mpimageW , height: mpdesiredImageViewH)
        mipassImage.contentMode = .scaleAspectFit
        virginView.addSubview(mipassImage)
        y = y + desiredImageViewH + 20
        
        // add button
        y = view.frame.height - 220
        let goButton = virginButton(btnY: y, text: "Continue")
        let goAction = UITapGestureRecognizer()
        goAction.addTarget(self, action: #selector(openUrl))
        goButton.addGestureRecognizer(goAction)
        virginView.addSubview(goButton)
        y = y + 80
        
        let backButton = virginButtonBack(btnY: y, text: "Back")
        let backAction = UITapGestureRecognizer()
        backAction.addTarget(self, action: #selector(closeVirgin))
        backButton.addGestureRecognizer(backAction)
        virginView.addSubview(backButton)
        
        self.view.addSubview(virginView)
    }
    
    @objc func closeVirgin(gesture: UITapGestureRecognizer) {
        virginView.removeFromSuperview()
    }
    
    @objc func openUrl(gesture: UITapGestureRecognizer) {
        guard let urlText = urlField.text,
              urlText.count > 0,
              let url = URL(string: urlText),
              url.host?.hasSuffix("hooyu.com") == true || url.host?.hasSuffix("miteksystems.com") == true
        else {
            // alert here
            urlField.text = ""
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let item = storyboard.instantiateViewController(withIdentifier: "HooyuWebViewController") as? HooyuWebViewController else {return}
        item.hooyuUrl = urlText
        item.closeDelegate = self
        item.modalPresentationStyle = .popover
        item.modalTransitionStyle = .crossDissolve
        
        if let popoverController = item.popoverPresentationController {
            // ipad fix for web view
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        self.present(item, animated: true, completion: nil)
    }
    
    private func addButton(btnY: CGFloat, text: String, inverted: Bool) -> UIView {
        let w = self.view.bounds.width
        
        let btn = UIView()
        let distance:CGFloat = 30
        let y:CGFloat = btnY + distance
        let h: CGFloat = 60
        btn.frame = CGRect(x: 20.0, y: y, width: w-40, height: h)
        btn.backgroundColor = ViewController.orange
        if inverted {
            btn.backgroundColor = UIColor.white
        }
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.layer.borderColor = ViewController.orange.cgColor
        btn.layer.borderWidth = 2
        
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
        textLabel.textColor = UIColor.white
        if inverted {
            textLabel.textColor = ViewController.orange
        }
        textLabel.frame = CGRect(x: 0, y: 0, width: w-40, height: h)
        btn.addSubview(textLabel)
        
        return btn
    }
    
    private func virginButton(btnY: CGFloat, text: String) -> UIView {
        let w = self.view.bounds.width
        
        let btn = UIView()
        let distance:CGFloat = 30
        let y:CGFloat = btnY + distance
        let h: CGFloat = 60
        btn.frame = CGRect(x: 20.0, y: y, width: w-40, height: h)
        btn.backgroundColor = ViewController.virgin
        btn.layer.cornerRadius = 1
        btn.layer.masksToBounds = true
        btn.layer.borderColor = ViewController.virgin.cgColor
        btn.layer.borderWidth = 2
        
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
        textLabel.textColor = UIColor.white
        textLabel.frame = CGRect(x: 0, y: 0, width: w-40, height: h)
        btn.addSubview(textLabel)
        
        return btn
    }
    
    private func virginButtonBack(btnY: CGFloat, text: String) -> UIView {
        let w = self.view.bounds.width
        
        let btn = UIView()
        let distance:CGFloat = 30
        let y:CGFloat = btnY + distance
        let h: CGFloat = 60
        btn.frame = CGRect(x: 20.0, y: y, width: w-40, height: h)
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 1
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 2
        
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
        textLabel.textColor = UIColor.gray
        textLabel.frame = CGRect(x: 0, y: 0, width: w-40, height: h)
        btn.addSubview(textLabel)
        
        return btn
    }

}

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
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

extension ViewController: WVCloseDelegate {
    func willClose() {
        virginView.removeFromSuperview()
        virginView = UIView(frame: view.frame)
        virginView.backgroundColor = UIColor.white
        
        var y:CGFloat = 60
        
        // add logo
        let logoWhite = UIImageView()
        let image = UIImage(named: "virgin_logo")!
        logoWhite.image = image
        let imageW = view.frame.width * 2/3
        let desiredImageViewH = (imageW / image.size.width) * image.size.height
        logoWhite.frame = CGRect(x: (view.frame.width - imageW)/2, y: y, width: imageW , height: desiredImageViewH)
        logoWhite.contentMode = .scaleAspectFit
        virginView.addSubview(logoWhite)
        y = y + desiredImageViewH + 100
        
        // add text
        let txtLabel = UILabel()
        txtLabel.text = "Thank you. Your biometric was verified"
        txtLabel.textAlignment = .center
        txtLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        txtLabel.numberOfLines = 0
        txtLabel.textColor = UIColor.gray
        txtLabel.frame = CGRect(x: 20, y: y, width: view.frame.width-40, height: 100)
        virginView.addSubview(txtLabel)
        
        y = view.frame.height - 140
        let backButton = virginButtonBack(btnY: y, text: "Back")
        let backAction = UITapGestureRecognizer()
        backAction.addTarget(self, action: #selector(closeVirgin))
        backButton.addGestureRecognizer(backAction)
        virginView.addSubview(backButton)
        
        self.view.addSubview(virginView)
    }
}

