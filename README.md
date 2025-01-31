# Orkestapay iOS 

Orkestapay iOS swift create payment methods and get promotions

## Installation

Orkestapay iOS are available through either [CocoaPods](http://cocoapods.org) or [Swift Package Manager](https://swift.org/package-manager/).

### Minimum Requirements

- iOS SDK 14+
- Swift 5.7

### Swift Package Manager

To add Orkestapay package to your Xcode project, select File > Add Packages and enter 
```bash
https://github.com/orkestapay/orkestapay-ios.git
```
as the repository URL 
or follow Apple's [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
) guide on how to add a Swift Package dependency.

### CocoaPods
To integrate Orkestapay into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Orkestapay'
```

Then, run the following command:

```bash
$ pod install
```
> Use the .xcworkspace file to open your project in Xcode.

# Usage

```swift
import Orkestapay
```

#### Create a instance 

For create an instance Orkestapay client needs:
- Merchant Id
- Public Key

```swift
let merchantId = "merchantId"
let publicKey = "publicKey"

var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
}
```

If you want to switch to production mode, you must send isProductionMode as true


#### Create a Device Session Id

Library contains a function to generate device session id

```swift
var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
  orkestapay.createDeviceSession(viewController: self, successSessionID: successSessionId, failureSessionID: failureSessionId)
}

func successSessionId(sessionId: String) {
  print("SessionId: \(sessionId)")
}

func failureSessionId(error: String) {
  print("error: \(error)")
}
```

#### Create Payment Method

Library contains a function to create a payment method

```swift
var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
  let card = Card(number: "4111111111111111", expirationMonth: "12", expirationYear: "2025", cvv: "123", holderName: "Hector Rodriguez", oneTimeUse: false)
  let paymentMethod = PaymentMethod(alias: "Test card", customerId: nil, deviceSessionId: deviceSessionId, card: card, billingAddress: nil)

  Task.init {
    do {
      let response = try await orkestapay.createPaymentMethod(paymentMethod: paymentMethod)
      print(response)
    } catch let error as OrkestapayError {
        print(error.errorDescription!)
    } catch {
        print(error.localizedDescription)
    }
  }
}
```

#### Get promotions

Library contains a function to get promotions

```swift
var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
  
  Task.init {
    do {
      let response = try await orkestapay.getPromotions(binNumber: "123456", currency: "MXN", totalAmount: "1000")
      print(response)
    } catch let error as OrkestapayError {
        print(error.errorDescription!)
    } catch {
        print(error.localizedDescription)
    }
  }
}
```

#### Click to Pay Checkout

Click to Pay Checkout
Library contains a function to open checkout to Click to Pay.

```swift
var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
  let clickToPay = ClickToPay(email: "custome@mail.com", firstName: "John", lastName: "Doe", phoneCountryCode: "52", phoneNumber: "4411223344", totalAmount: "100", currency: "MXN", isCscRequired: true, isSandbox: true)
  
  orkestapay.clickToPayCheckout(clickToPay: clickToPay, onSuccess: { paymentMethod in
      print("clickToPay success: \(paymentMethod)")
  }, onError: {error in
      print("clickToPay error: \(error)")
  }, onCancel: {
      print("clickToPay cancel")
  })
}
```

#### Apple Pay

Library contains a function to create payment method through Apple Pay.

##### Setup your integration
Enable Apple Pay in your app
Log in to your Apple Developer account at https://developer.apple.com.<br />
Follow the Apple Developer Account Help instructions to enable [Apple Pay](https://developer.apple.com/help/account/manage-identifiers/enable-app-capabilities#enable-apple-pay).

Adding Capability<br />
Move to your target , select your app as your target. Click on Signing & Capabilities . Click on the + icon and select apple pay, if all went well , you will see your merchant id already, if its not selected select it or follow Apple's guide to [Add Capability](https://developer.apple.com/documentation/xcode/configuring-apple-pay-support)

##### Apple Pay request
```swift
var orkestapay: OrkestapayClient!

func myFunction() {
  orkestapay  = OrkestapayClient(merchantId: merchantId, publicKey: publicKey, isProductionMode: false)
  
  let applePayRequest = ApplePayRequest(merchantName: "Merchant name", totalAmount: "500", countryCode: "MX", currencyCode: "MXN")
  orkestapay.applePayChechout(applePayRequest: applePayRequest, onSuccess: { paymentMethod in
      print("apple pay success: \(paymentMethod)")
  }, onError: {error in
      print("apple pay error: \(error)")
  }, onCancel: {
      print("clickToPayCancel")
  })
}
```


