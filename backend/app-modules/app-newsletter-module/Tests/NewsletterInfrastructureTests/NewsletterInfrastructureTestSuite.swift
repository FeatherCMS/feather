import Testing
@testable import NewsletterInfrastructure

@Suite
struct NewsletterInfrastructureTestSuite {
    @Test
    func infrastructureTargetLoads() {
        #expect(String(describing: NewsletterInfrastructureModule.self).contains("NewsletterInfrastructureModule"))
    }
}
