import ContactDomain
import Testing

import struct Foundation.Date

@testable import ContactApplication

@Suite
struct ContactApplicationTestSuite {
    @Test
    func formDetailMappingPreservesConfiguredValues() {
        let date = Date(timeIntervalSince1970: 1_000)
        let form = Form.Model(
            id: "form-1",
            key: "contact",
            name: "Contact",
            successMessage: "Thanks",
            failureMessage: "Try again",
            redirectUrl: "/done",
            createdAt: date,
            updatedAt: date
        )

        let detail = form.asDetail

        #expect(detail.id == "form-1")
        #expect(detail.key == "contact")
        #expect(detail.successMessage == "Thanks")
        #expect(detail.failureMessage == "Try again")
        #expect(detail.redirectUrl == "/done")
        #expect(detail.createdAt == date)
        #expect(detail.updatedAt == date)
    }
}
