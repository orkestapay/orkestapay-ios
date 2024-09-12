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
  let clickToPay = ClickToPay(email: "custome@mail.com", firstName: "John", lastName: "Doe", phoneCountryCode: "52", phoneNumber: "4411223344", isSandbox: true)
  
  orkestapay.clickToPayCheckout(clickToPay: clickToPay, completed: {paymentMethod in
      print("clickToPayCompleted: \(paymentMethod)")
  }, error: {error in
      print("clickToPayError: \(error)")
  }, cancel: {
      print("clickToPayCancel")
  })
}
```


