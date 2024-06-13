

import XCTest
@testable import Orkestapay


final class OrkestapayTests: XCTestCase {
    var orkestapay: OrkestapayClient!


    func testGetPromotions() async throws {
        let orkestapay  = OrkestapayClient(merchantId: "mid_mch_591bbfb20c324605877afc9b01d715c3", publicKey: "pk_test_c50ogjsxw0uhir2wc9kx0uxily0kzwj2", isProductionMode: false)

        let response = try await orkestapay.getPromotions(binNumber: "477291", currency: "MXN", totalAmount: "1000")
        print(response)
        XCTAssertNotNil(response.first?.promotionId)
        /*if let promotion = response.first {
            let installments = promotion.installments.map { promo in
                String(promo)
            }.joined(separator: ",")
            print(installments)
        }*/
 
    }
}
