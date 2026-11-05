import Configuration
import Foundation
import Testing

@testable import Worker

@Suite
struct WorkerConfigLoaderTests {

    @Test
    func workerLoaderOwnsThePublicSiteOrigin() throws {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "https://example.com"
                ])
            ]
        )

        let config = try WorkerConfig.Loader().load(reader: reader)

        #expect(config.webPublicBaseURL.absoluteString == "https://example.com")
    }

    @Test
    func workerLoaderRejectsInvalidPublicSiteOrigin() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "file:///tmp/site"
                ])
            ]
        )

        #expect(throws: WorkerConfig.Error.self) {
            try WorkerConfig.Loader().load(reader: reader)
        }
    }
}
