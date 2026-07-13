import Testing
@testable import ContactApplication

@Suite
struct ContactApplicationTestSuite {
    @Test
    func applicationTargetLoads() {
        #expect(String(describing: ContactApplicationModule.self).contains("ContactApplicationModule"))
    }
}
