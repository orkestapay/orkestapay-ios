//
//  DemoTests.swift
//  DemoTests
//
//  Created by Hector Rodriguez on 11/06/24.
//

import XCTest
import UIKit
@testable import Demo
@testable import Orkestapay


final class DemoTests: XCTestCase {
    var orkestapay: OrkestapayClient!
    
    func makeSUT() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "viewController") as! ViewController
        sut.loadViewIfNeeded()
        return sut
    }
    
    func testCreateDeviceSession() throws {
        let orkestapay  = OrkestapayClient(merchantId: "mid_mch_591bbfb20c324605877afc9b01d715c3", publicKey: "pk_test_c50ogjsxw0uhir2wc9kx0uxily0kzwj2", isProductionMode: false)
        let exp = expectation(description: "Test after 20 seconds")

        let completion = { string in
            XCTAssertNotNil(string)
            exp.fulfill()
        }
        
        let failure = { string in
            XCTAssertNil(string)
            exp.fulfill()
        }
        
        let sut = makeSUT()
        
         sut.viewDidLoad()
        
        orkestapay.createDeviceSession(viewController: sut, successSessionID: completion, failureSessionID: failure)
        wait(for: [exp], timeout: 30.0)
      
    }
    
    func testCreatePaymentMethod() async throws {
        let orkestapay  = OrkestapayClient(merchantId: "mid_mch_591bbfb20c324605877afc9b01d715c3", publicKey: "pk_test_c50ogjsxw0uhir2wc9kx0uxily0kzwj2", isProductionMode: false)
        
        let card = Card(number: "4111111111111111", expirationMonth: "12", expirationYear: "2025", cvv: "123", holderName: "Hector Rodriguez", oneTimeUse: true)
        //let billingAddress = BillingAddress(firstName: nil, lastName: nil, email: nil, phone: nil, type: nil, line1: "Calle conocida", line2: nil, city: "Queretaro", state: "Queretaro", country: "MX", zipCode: "76500")
        let paymentMethod = PaymentMethod(alias: "Test card", customerId: nil, deviceSessionId: "ea890ed3-4016-4da2-8228-56ddae19c619", card: card, billingAddress: nil)
     
        let response = try await orkestapay.createPaymentMethod(paymentMethod: paymentMethod)
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.paymentMethodId)
      
    }
    
    func testGetPromotions() async throws {
        let orkestapay  = OrkestapayClient(merchantId: "mid_mch_591bbfb20c324605877afc9b01d715c3", publicKey: "pk_test_c50ogjsxw0uhir2wc9kx0uxily0kzwj2", isProductionMode: false)
     
        let response = try await orkestapay.getPromotions(binNumber: "477291", currency: "MXN", totalAmount: "1000")
        XCTAssertNotNil(response)
        XCTAssertNotNil(response.first?.promotionId)
      
    }
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
