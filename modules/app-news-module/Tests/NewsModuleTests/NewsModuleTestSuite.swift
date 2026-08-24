import NewsContracts
import Testing

@testable import NewsApplication

@Suite
struct NewsModuleTestSuite {

    @Test
    func applicationTargetLoads() {
        _ = NewsPermissions.self
    }
}
