# MiVIP SDK v.3.6.4 for iOS

![Platform](https://img.shields.io/cocoapods/p/MiVIP.svg?color=darkgray)
![CocoaPods version](https://img.shields.io/cocoapods/v/MiVIP?color=success)
![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen)
![Carthage](https://img.shields.io/badge/Carthage-incompatible-red)

MiVIP’s Native SDK is a fully orchestrated user interface and user journey delivered as an SDK for seamless integration into any native application. The functionality is replicated from the existing Web journey where the same orchestration and white-label customisations are applied, as configured in one centralised location via the web portal. The SDK is packaged together with Mitek’s capture technology, MiSnap. Mitek’s customers can benefit from both Mitek’s market leading capture experience combined with a completely pre-built dynamic user journey, all delivered in a single packaged SDK with low code integration for minimum integration effort and accelerated time to live.


- - -

# System Requirements

<center>

| Technology | Version |
| :--- | :---: |
| MiSnap | 5.6.1 |
| Xcode | 14.0 |
| iOS | 13.0 |
| iPhone | 7 |

</center>

For MiSnap integration visit [MiSnap iOS repository](https://github.com/Mitek-Systems/MiSnap-iOS)

- - -

# Adding to your project

## [Cocoapods](https://guides.cocoapods.org/using/using-cocoapods.html)
* add MiVIP pod dependancy. It will download all needed dependancies including MiSnap
```
  pod 'MiVIP', '3.6.1'
```
* Obtain MiSnap [license key ](https://github.com/Mitek-Systems/MiSnap-iOS?tab=readme-ov-file#license-key)

## [Swift Package Manager (SPM)](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)
* Add [MiSnap SDKs](https://github.com/Mitek-Systems/MiSnap-iOS) and obtain a license key
* Add MiVIP package dependancies (https://github.com/Mitek-Systems/MiVIP-iOS) 
* Add external dependancy [SocketRocket](https://github.com/facebookincubator/SocketRocket) version 0.6.1


## Manual Installation
* Add [MiSnap SDKs](https://github.com/Mitek-Systems/MiSnap-iOS) and obtain a license key
* Add MiVIP SDKs to frameworks folder of your project (drag to XCode)
* Choose option 'Embed & Sign' for your target(s)
* Add external dependancy [SocketRocket](https://github.com/facebookincubator/SocketRocket) version 0.6.1

- - -

# SDK usage

```swift
import MiVIPSdk
import MiVIPApi
…

let mivip = MiVIPHub()
mivip.setSoundsDisabled(true) // enable/disable short sound/vibration notification (e.g. when document processing completes)
mivip.setReusableEnabled(false) // disable/enable wallet option
…

// Start SDK with request QR code scan option
mivip.qrCode(vc: self, requestStatusDelegate: self)

// Open ID request
let idRequest = "35cd1bf3-553b-485e-822f-bba55c9b03e3"
mivip.request(vc: self, miVipRequestId: idRequest, requestStatusDelegate: self)
```

to get notification from SDK on request status changes, implement the RequestStatusDelegate

```swift
extension ViewController: MiVIPSdk.RequestStatusDelegate {

    func status(status: MiVIPApi.RequestStatus?, result: MiVIPApi.RequestResult?, scoreResponse: MiVIPApi.ScoreResponse?, request: MiVIPApi.MiVIPRequest?) {
        ...
    }

    func error(err: String) {
        ...
    }
    
}
```

- - -

# SDKs Files and Sizes

* MiVIPApi.xcframework - includes API calls and handle results.
* MiVIPLiveness.xcframework - implementation of active liveness.
* MiVIPSDK.xcframework - includes journey orchestration and UI.

<center>

| Component                        | Compressed     | Uncompressed     |
| :------------------------------- | :------------: | :--------------: |
| MiVIPApi                         |  550KB         |  1.6MB           |
| MiVIPLiveness                    |  74KB          |  200KB           |
| MiVIPSDK                         |  13MB          |  15MB            |
| All + external dependancies      |  13.7MB        |  17.2MB          |


</center>

Sizes are taken from "App Thinning Size Report.txt" of an Xcode distribution package for the latest iOS version where `compressed` is your app download size increase, and `uncompressed` size is equivalent to the size increase of your app once installed on the device. 

In most cases you should be interested in `compressed` size since this is the size increase to your installable on AppStore that has network limitations depending on the size.

Refer to "Create the App Size Report" section of [this article](https://developer.apple.com/documentation/xcode/reducing-your-app-s-size#Create-the-App-Size-Report) for more details.

- - -

# Third-Party Licensing Info
* [MiVIPSdk](Docs/3rd_party_licensing_info.md)

- - -

# Integration Guide
* [MiVIPSdk](Docs/dev_guide_ios.md)

