import Configuration
import FeatherWebShared
import Foundation
import Testing

@testable import Static
@testable import WebApp

@Suite
struct AppEnvironmentConfigTestSuite {

    @Test
    func webAppConfigUsesTargetDefaults() throws {
        let reader = ConfigReader(
            providers: [InMemoryProvider(values: [:])]
        )

        let config = try WebAppConfigLoader().load(reader: reader)

        #expect(config.host == "0.0.0.0")
        #expect(config.port == 3456)
        #expect(config.serverName == "web-app")
        #expect(config.apiBaseURL.absoluteString == "http://localhost:8080")
        #expect(
            config.publicSiteBaseURL.absoluteString
                == "http://localhost:3456"
        )
        #expect(
            config.publicStaticBaseURL.absoluteString
                == "http://localhost:4567"
        )
        #expect(
            config.publicMediaBaseURL.absoluteString
                == "http://localhost:8081"
        )
    }

    @Test
    func webAppConfigUsesExplicitOriginsAndListenerValues() throws {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "http.host": "127.0.0.1",
                    "http.port": 3457,
                    "http.serverName": "preview",
                    "api.baseURL": "https://api.example.com",
                    "web.publicBaseURL": "https://example.com",
                    "static.publicBaseURL": "https://static.example.com",
                    "media.publicBaseURL": "https://media.example.com",
                ])
            ]
        )

        let config = try WebAppConfigLoader().load(reader: reader)

        #expect(config.host == "127.0.0.1")
        #expect(config.port == 3457)
        #expect(config.serverName == "preview")
        #expect(config.apiBaseURL.absoluteString == "https://api.example.com")
        #expect(
            config.publicSiteBaseURL.absoluteString == "https://example.com"
        )
        #expect(
            config.publicStaticBaseURL.absoluteString
                == "https://static.example.com"
        )
        #expect(
            config.publicMediaBaseURL.absoluteString
                == "https://media.example.com"
        )
    }

    @Test
    func webAppConfigRejectsInvalidPublicURL() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "file:///tmp/site"
                ])
            ]
        )

        #expect(throws: WebAppConfigurationError.self) {
            try WebAppConfigLoader().load(reader: reader)
        }
    }

    @Test
    func webAppConfigRejectsIncompleteTurnstileCredentials() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: ["turnstile.key": "site-key"])
            ]
        )

        #expect(throws: TurnstileConfigurationError.self) {
            try WebAppConfigLoader().load(reader: reader)
        }
    }

    @Test
    func staticConfigUsesIndependentDefaultsAndOverrides() {
        let defaultConfig = StaticConfigLoader().load(
            reader: ConfigReader(
                providers: [InMemoryProvider(values: [:])]
            )
        )
        let overriddenConfig = StaticConfigLoader().load(
            reader: ConfigReader(
                providers: [
                    InMemoryProvider(values: [
                        "http.host": "127.0.0.1",
                        "http.port": 4568,
                        "http.serverName": "static-preview",
                    ])
                ]
            )
        )

        #expect(defaultConfig.host == "0.0.0.0")
        #expect(defaultConfig.port == 4567)
        #expect(defaultConfig.serverName == "static")
        #expect(overriddenConfig.host == "127.0.0.1")
        #expect(overriddenConfig.port == 4568)
        #expect(overriddenConfig.serverName == "static-preview")
    }

    @Test
    func secureCookiesFollowPublicSiteScheme() {
        let httpOrigins = AppPublicOriginConfiguration(
            siteBaseURL: "http://localhost:3456",
            staticBaseURL: "http://localhost:4567",
            mediaBaseURL: URL(string: "http://localhost:8080")!
        )
        let httpsOrigins = AppPublicOriginConfiguration(
            siteBaseURL: "https://cms.example.com",
            staticBaseURL: "https://static.example.com",
            mediaBaseURL: URL(string: "https://media.example.com")!
        )

        #expect(httpOrigins.usesSecureCookies == false)
        #expect(httpsOrigins.usesSecureCookies)
    }
}
