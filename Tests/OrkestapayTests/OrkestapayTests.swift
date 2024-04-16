import XCTest
@testable import Orkestapay
import JavaScriptCore


final class OrkestapayTests: XCTestCase {


    func testDeviceInfo() throws {

        let context = JSContext()!
        //let scriptURL = Bundle.main.url(forResource: "orkestapay", withExtension: "js")!
        let script = try! String(contentsOf: URL(string: "http://checkout.dev.orkestapay.com/script/orkestapay.js")!)
        context.evaluateScript(script)
        
        let merchantId = "mch_1a06356c660d4552b0d873b43d227071"
        let publicKey = "pk_test_vlvzqfkkycg4tpw9p340g63hc5zmwbbg"
        
        print("initOrkestaPay({merchant_id: '\(merchantId)', public_key:'\(publicKey)'})")
        
        let orkestapay = context.evaluateScript("const orkestapay = initOrkestaPay({merchant_id: '\(merchantId)', public_key:'\(publicKey)'})")
        print(orkestapay!)
        let deviceInfo = context.evaluateScript("(async function () { const deviceInfo = await orkestapay.getDeviceInfo();})();")
        print(deviceInfo!)
 
    }
}
