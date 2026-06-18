import Testing
@testable import MediaDomain

@Test("MediaDomain loads")
func mediaDomainLoads() {
    _ = MediaDomainModule.self
}
