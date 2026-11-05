import Configuration
import Foundation
import Testing

@testable import Migrator

@Suite
struct MigratorConfigLoaderTests {

    @Test
    func migratorLoaderRequiresAndParsesThePublicSiteOrigin() throws {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "https://example.com"
                ])
            ]
        )

        let config = try MigratorConfigLoader().load(reader: reader)

        #expect(config.webPublicBaseURL.absoluteString == "https://example.com")
    }

    @Test
    func migratorLoaderRejectsMissingAndInvalidPublicSiteOrigins() {
        let missingReader = ConfigReader(
            providers: [InMemoryProvider(values: [:])]
        )
        let invalidReader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "file:///tmp/site"
                ])
            ]
        )

        #expect(throws: MigratorConfigurationError.self) {
            try MigratorConfigLoader().load(reader: missingReader)
        }
        #expect(throws: MigratorConfigurationError.self) {
            try MigratorConfigLoader().load(reader: invalidReader)
        }
    }
}
