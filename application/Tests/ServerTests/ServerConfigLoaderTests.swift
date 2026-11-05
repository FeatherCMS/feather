import Configuration
import Foundation
import Testing

@testable import Server

@Suite
struct ServerConfigLoaderTests {

    @Test
    func serverLoaderReadsAndValidatesItsMediaOrigin() throws {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "media.public_base_url": "https://media.example.com"
                ])
            ]
        )

        let config = try ServerConfig.Loader().load(reader: reader)

        #expect(
            config.media.publicBaseURL.absoluteString
                == "https://media.example.com"
        )
    }

    @Test
    func serverLoaderRejectsInvalidMediaOrigin() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "media.public_base_url": "file:///tmp/media"
                ])
            ]
        )

        #expect(throws: ServerConfig.Error.self) {
            try ServerConfig.Loader().load(reader: reader)
        }
    }
}
