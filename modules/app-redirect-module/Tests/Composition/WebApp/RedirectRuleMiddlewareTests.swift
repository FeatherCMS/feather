import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import FeatherWebAdmin
import Foundation
import Hummingbird
import HummingbirdTesting
import RedirectAppAPI
import RedirectWebApp
import Testing

@Suite
struct RedirectRuleMiddlewareTests {
    @Test
    func defaultResolverOnlyLooksUpNotFoundReadRequests() {
        let resolver = DefaultRedirectRuleResolver(
            apiBaseURL: URL(fileURLWithPath: "/")
        )

        #expect(
            resolver.shouldLookupRedirect(
                path: "/missing",
                method: "GET",
                responseCode: 404
            )
        )
        #expect(
            resolver.shouldLookupRedirect(
                path: "/missing",
                method: "HEAD",
                responseCode: 404
            )
        )
        #expect(
            !resolver.shouldLookupRedirect(
                path: "/missing",
                method: "POST",
                responseCode: 404
            )
        )
        #expect(
            !resolver.shouldLookupRedirect(
                path: "/existing",
                method: "GET",
                responseCode: 200
            )
        )
        #expect(
            !resolver.shouldLookupRedirect(
                path: "/admin/users",
                method: "GET",
                responseCode: 404
            )
        )
        #expect(
            !resolver.shouldLookupRedirect(
                path: "/assets/site.css",
                method: "GET",
                responseCode: 404
            )
        )
        #expect(
            !resolver.shouldLookupRedirect(
                path: "/health",
                method: "GET",
                responseCode: 404
            )
        )
    }

    @Test
    func middlewareResolvesRootPath() async throws {
        let executor = makeExecutor(
            path: "/",
            resolve: { source in
                guard source == "/" else { return nil }
                return .init(
                    source: source,
                    destination: "/home",
                    statusCode: 301
                )
            }
        )
        let response = try await executor.withOperation(
            request: FeatherHTTP.Request(method: .get, path: "/")
        ) { $0.response }

        #expect(response.status.code == 301)
    }

    @Test
    func middlewarePreservesTrailingSlashInSource() async throws {
        let executor = makeExecutor(
            path: "/news/",
            resolve: { source in
                guard source == "/news/" else { return nil }
                return .init(
                    source: source,
                    destination: "/latest",
                    statusCode: 302
                )
            }
        )
        let response = try await executor.withOperation(
            request: FeatherHTTP.Request(method: .get, path: "/news/")
        ) { $0.response }

        #expect(response.status.code == 302)
    }

    @Test
    func middlewareKeepsOriginalNotFoundWhenResolverFails() async throws {
        let executor = makeExecutor(
            path: "/unavailable",
            resolve: { _ in
                throw ResolverError.unavailable
            }
        )
        let response = try await executor.withOperation(
            request: FeatherHTTP.Request(method: .get, path: "/unavailable")
        ) { $0.response }

        #expect(response.status.code == 404)
    }
}

private enum ResolverError: Error, Sendable {
    case unavailable
}

private struct TestRedirectRuleResolver: RedirectRuleResolver {
    let resolve:
        @Sendable (String) async throws ->
            RedirectAppAPI.Components.Schemas.RedirectRuleSchema?

    func shouldLookupRedirect(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        responseCode == 404
    }

    func resolveRedirect(
        source: String
    ) async throws -> RedirectAppAPI.Components.Schemas.RedirectRuleSchema? {
        try await resolve(source)
    }
}

private func makeExecutor(
    path: String,
    resolve:
        @escaping @Sendable (String) async throws ->
        RedirectAppAPI.Components.Schemas.RedirectRuleSchema?
) -> HummingbirdTestingHTTPExecutor {
    let middleware = RedirectRuleMiddleware(
        siteBaseURL: "https://example.test",
        resolver: TestRedirectRuleResolver(resolve: resolve)
    )
    let router = Router(context: DefaultRequestContext.self)
    router.addMiddleware { middleware }
    router.get(RouterPath(path)) { _, _ in Response(status: .notFound) }
    return HummingbirdTestingHTTPExecutor(
        app: Application(router: router),
        testingSetup: .router
    )
}
