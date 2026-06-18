import Testing
@testable import MediaApplication

@Test("MediaApplication loads")
func mediaApplicationLoads() {
    _ = MediaApplicationModule.self
}
