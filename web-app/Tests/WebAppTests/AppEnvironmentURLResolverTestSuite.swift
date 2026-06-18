import Configuration
import Foundation
import Testing

@testable import WebApp

@Suite
struct AppEnvironmentURLResolverTestSuite {

    @Test
    func resolverUsesExplicitPublicBaseURLs() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [
                    "web.publicBaseURL": "http://192.168.8.102:3456",
                    "static.publicBaseURL": "http://192.168.8.102:4567",
                    "media.publicBaseURL": "http://192.168.8.102:8080",
                    "api.baseURL": "http://server:8080",
                ])
            ]
        )

        let resolver = AppEnvironmentURLResolver(reader: reader)

        #expect(resolver.publicSiteBaseURL() == "http://192.168.8.102:3456")
        #expect(resolver.publicStaticBaseURL() == "http://192.168.8.102:4567")
        #expect(resolver.publicMediaBaseURL() == "http://192.168.8.102:8080")
        #expect(resolver.apiBaseURL() == "http://server:8080")
    }

    @Test
    func resolverFallsBackToLocalhostDefaults() {
        let reader = ConfigReader(
            providers: [
                InMemoryProvider(values: [:])
            ]
        )

        let resolver = AppEnvironmentURLResolver(reader: reader)

        #expect(resolver.publicSiteBaseURL() == "http://localhost:3456")
        #expect(resolver.publicStaticBaseURL() == "http://localhost:4567")
        #expect(resolver.publicMediaBaseURL() == "http://localhost:8080")
        #expect(resolver.apiBaseURL() == "http://localhost:8080")
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
