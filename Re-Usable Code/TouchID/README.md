
# TouchID 101 
-----
Works with:
[![IDE](https://img.shields.io/badge/Xcode-9-blue.svg)](https://developer.apple.com/xcode/)
[![Language](https://img.shields.io/badge/swift-4-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2011-green.svg)](https://developer.apple.com/ios/)

Protecting an app with a login screen is a great way to secure user data – you can use the Keychain, which is built right in to iOS, to ensure their data stays secure. Apple also offered another layer of protection with Touch ID starting iphone 5s, and later with Face ID with iPhone X

The basic are covered on the ff. and further security layers will applied once tested.

### TouchID and FaceID Feature
-----
For TouchID, you can store up to five finger prints with Touch ID so you could store different user’s fingerprints. It’s generally discouraged to do that since without some extra checks there’s no way to separate which user uses which fingerprint. (Available since the iPhone 5S, biometric data is stored in a secure enclave in the A7 and newer chips.)

For Face ID, it only stores one “face print”. So, it is not possible to store for logins multiple users on the same device.(Only available for iPhoneX)

------

REF:
See the step by step and much more comprehensive guide through Ray Wenderlich :D:
https://www.raywenderlich.com/179924/secure-ios-user-data-keychain-biometrics-face-id-touch-id


Read more about securing your iOS apps in Apple’s official iOS Security Guide here:
https://www.apple.com/business/docs/iOS_Security_Guide.pdf

FOR FURTHER READING:

FROM: OWASP: Open Web Application Security Project - 
ref: https://www.owasp.org/index.php/About_The_Open_Web_Application_Security_Project

https://www.owasp.org/index.php/IOS_Developer_Cheat_Sheet

https://www.owasp.org/index.php/IOS_Application_Security_Testing_Cheat_Sheet
