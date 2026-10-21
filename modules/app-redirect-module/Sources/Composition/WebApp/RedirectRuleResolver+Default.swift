public import Foundation
public import RedirectAppAPI

/// Resolves redirects through the generated App API client.
public struct DefaultRedirectRuleResolver: RedirectRuleResolver {
    private let apiBaseURL: URL
    private let excludedPaths = ["/health", "/admin", "/login", "/logout"]
    private let staticAssetExtensions: Set<String> = [
        ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp",
        ".ico",
    ]

    /// Creates a resolver targeting the redirect App API at `apiBaseURL`.
    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    /// Looks up eligible 404 GET/HEAD requests, excluding app and asset paths.
    public func shouldLookupRedirect(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        guard responseCode == 404 && ["GET", "HEAD"].contains(method) else {
            return false
        }

        let normalizedPath = path.lowercased()
        return
            !excludedPaths.contains(where: {
                normalizedPath == $0 || normalizedPath.hasPrefix("\($0)/")
            })
            && !staticAssetExtensions.contains(where: normalizedPath.hasSuffix)
    }

    /// Fetches a redirect rule for the supplied normalized source path.
    public func resolveRedirect(
        source: String
    ) async throws -> RedirectAppAPI.Components.Schemas
        .RedirectRuleSchema?
    {
        let api = API.AppClient(apiBaseURL: apiBaseURL)
        let response: RedirectAppAPI.Operations.RedirectRuleGet.Output
        response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.redirectRuleGet(
                .init(query: .init(source: source))
            )
        }

        switch response {
        case .ok(let ok):
            return try ok.body.json
        case .notFound, .undocumented:
            return nil
        }
    }
}
