//
//  QRScanViewController.swift
//  HooyuWView
//
//  View to scan HooYu request QR code and open it in webview
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var rect: CGRect?
    private var rectLayer = CAShapeLayer()
    private var requestView: UIView?
    private var started = false
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let cancelButtonTitle = "Cancel"
        let titleNormal = NSAttributedString(string: cancelButtonTitle, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.white])
        button.setAttributedTitle(titleNormal, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // UI
        let screensize: CGRect = previewLayer.bounds
        let screenWidth = screensize.width
        
        // Add header
        let height:CGFloat = 150
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
        
        // logo
        let logoWhite = UIImageView()
        let image =  UIImage(named: "logo_white")!
        logoWhite.image = image
        let imageH = height/3.6
        let imageY = (height-imageH)/2
        let desiredImageViewWidth = (imageH / image.size.height) * image.size.width
        logoWhite.frame = CGRect(x: 25, y: imageY, width: desiredImageViewWidth , height: imageH)
        logoWhite.contentMode = .scaleAspectFit
        header.addSubview(logoWhite)
        
        // text
        let textLabel = UILabel()
        
        textLabel.text = "Scan QR code"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.2
        textLabel.textColor = UIColor.white
        let textY = imageY + imageH + 1
        textLabel.frame = CGRect(x: 25, y: textY, width: screenWidth-60, height: height/3)
        header.addSubview(textLabel)
        
        header.setGradientBackground(colorOne: ViewController.lightOrange, colorTwo: ViewController.orange)
        self.view.addSubview(header)
        
        self.view.addSubview(cancelButton)
        let cancelButtonConstraints = [
            cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: (65.0 / 2) - 10.0)
        ]
        NSLayoutConstraint.activate(cancelButtonConstraints)
        
        // rectangle
        let captureDeviceResolution = self.view.layer.bounds
        let w:CGFloat = captureDeviceResolution.width/1.5
        let x:CGFloat = captureDeviceResolution.width/2 - w/2
        let y:CGFloat = captureDeviceResolution.height/2 - w/2
        rect = CGRect(x: x, y: y, width: w, height: w)
        let path = drawRectangle(r: rect!)
        rectLayer = CAShapeLayer()
        rectLayer.path = path.cgPath
        rectLayer.strokeColor = UIColor.white.cgColor
        rectLayer.fillColor = UIColor.clear.cgColor
        rectLayer.lineWidth = 5
        previewLayer.addSublayer(rectLayer)
        
        captureSession.startRunning()
    }
    
    @objc func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(qrUrl: stringValue)
        }
    }
    
    /// called when QR code detected
    func found(qrUrl: String) {
        guard let url = buildUrl(qrUrl: qrUrl) else {
            captureSession.startRunning()
            return
        }
        
        rectLayer.removeFromSuperlayer()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let item = storyboard.instantiateViewController(withIdentifier: "HooyuWebViewController") as? HooyuWebViewController else {return}
        item.modalPresentationStyle = .popover
        item.modalTransitionStyle = .coverVertical
        item.hooyuUrl = url
        if let popoverController = item.popoverPresentationController {
            // ipad fix
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        // open webview from main VC
        guard let presentingVc = self.presentingViewController as? ViewController else {return}
        self.dismiss(animated: false) {
            presentingVc.present(item, animated: true, completion: nil)
        }
    }
    
    /// convert QR code app URL to request URL if possible
    private func buildUrl(qrUrl: String) -> String? {
        print(qrUrl)
        
        guard let url = URL(string:qrUrl),
                url.host?.hasSuffix("hooyu.com") == true || url.host?.hasSuffix("miteksystems.com") == true else { return nil}
        
        var request: String?
        var lang: String?
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = (urlComponents?.queryItems)! as [NSURLQueryItem]
        for it in items {
            switch it.name {
            case "idRequest":
                request = it.value
            case "l":
                lang = it.value
            default:
                debugPrint("No idRequest in URL")
            }
        }
        
        if request == nil {
            debugPrint("No idRequest in URL")
            return nil
        }
        
        if lang == nil {
            lang = "en"
        }
        
        let finalUrl: String = "https://\(url.host!)/\(lang!)/checkid/request/\(request!)"
        return finalUrl
    }
    
    private func drawRectangle(r: CGRect) -> UIBezierPath {
        let segLength : CGFloat = r.height/6
        let cornerSize : CGFloat = 10
        
        let p = UIBezierPath()
        
        // draw top left corner
        p.move(to: CGPoint(x:r.minX, y:r.minY + segLength + cornerSize))
        p.addLine(to: CGPoint(x:r.minX, y:r.minY + cornerSize))
        p.addArc(withCenter: CGPoint(x:r.minX + cornerSize, y:r.minY + cornerSize),
                 radius: cornerSize, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
        p.addLine(to:CGPoint(x:r.minX + segLength + cornerSize, y:r.minY))
        
        // draw top right corner
        p.move(to: CGPoint(x:r.maxX - segLength - cornerSize, y:r.minY ))
        p.addLine(to: CGPoint(x:r.maxX - cornerSize, y:r.minY ))
        p.addArc(withCenter: CGPoint(x:r.maxX - cornerSize, y:r.minY + cornerSize),
                 radius: cornerSize, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise: true)
        p.addLine(to:CGPoint(x:r.maxX, y:r.minY + segLength + cornerSize))
        
        // draw bottom right corner
        p.move(to: CGPoint(x:r.maxX, y:r.maxY - segLength - cornerSize))
        p.addLine(to: CGPoint(x:r.maxX, y:r.maxY - cornerSize ))
        p.addArc(withCenter: CGPoint(x:r.maxX - cornerSize, y:r.maxY - cornerSize),
                 radius: cornerSize, startAngle: 0, endAngle: CGFloat.pi * 0.5, clockwise: true)
        p.addLine(to:CGPoint(x:r.maxX - segLength - cornerSize, y:r.maxY))
        
        // draw bottom left corner
        p.move(to: CGPoint(x:r.minX + segLength + cornerSize, y:r.maxY))
        p.addLine(to: CGPoint(x:r.minX + cornerSize, y:r.maxY ))
        p.addArc(withCenter: CGPoint(x:r.minX + cornerSize, y:r.maxY - cornerSize),
                 radius: cornerSize, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi, clockwise: true)
        p.addLine(to:CGPoint(x:r.minX, y:r.maxY - segLength - cornerSize))
        
        return p
    }
    
}
