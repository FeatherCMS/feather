import AppOpenAPI
import Foundation
import HTTPTypes
import Hummingbird

struct RedirectRuleMiddleware: RouterMiddleware {

    let apiBaseURL: URL
    let siteBaseURL: String

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: @concurrent (Request, AppRequestContext) async throws -> Response
    ) async throws -> Response {
        let path = request.uri.path
        guard shouldLookupRedirect(for: path) else {
            return try await next(request, context)
        }

        let api = ApplicationAPI(apiBaseURL: apiBaseURL)
        guard let rule = try await matchedRedirectRule(api: api, path: path)
        else {
            return try await next(request, context)
        }

        return Response(
            status: redirectStatus(for: rule.statusCode),
            headers: [
                .location: normalizedDestination(
                    from: rule.destination,
                    siteBaseURL: siteBaseURL
                ),
                .cacheControl: "no-store, no-cache, must-revalidate",
                HTTPField.Name("pragma")!: "no-cache",
            ]
        )
    }

    private func shouldLookupRedirect(
        for path: String
    ) -> Bool {
        if path == "/health" || path == "/admin-navigation.js"
            || path == "/style.css"
        {
            return false
        }
        if path.hasPrefix("/admin/") || path == "/admin" {
            return false
        }
        if path.hasPrefix("/login/") || path == "/login" {
            return false
        }
        if path.hasPrefix("/logout/") || path == "/logout" {
            return false
        }

        let lowercased = path.lowercased()
        for suffix in [
            ".css",
            ".js",
            ".png",
            ".jpg",
            ".jpeg",
            ".gif",
            ".svg",
            ".webp",
            ".ico",
        ] where lowercased.hasSuffix(suffix) {
            return false
        }
        return true
    }

    private func redirectStatus(
        for code: Int
    ) -> HTTPResponse.Status {
        switch code {
        case 301:
            return .movedPermanently
        case 302:
            return .found
        case 307:
            return .temporaryRedirect
        case 308:
            return .permanentRedirect
        default:
            return .found
        }
    }

    private func matchedRedirectRule(
        api: ApplicationAPI,
        path: String
    ) async throws -> Components.Schemas.RedirectRuleSchema? {
        for candidate in redirectSourceCandidates(for: path) {
            let response: Operations.RedirectRuleGet.Output
            do {
                response = try await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    try await client.redirectRuleGet(
                        .init(query: .init(source: candidate))
                    )
                }
            }
            catch {
                return nil
            }

            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound, .undocumented:
                continue
            }
        }
        return nil
    }

    private func redirectSourceCandidates(
        for path: String
    ) -> [String] {
        let trimmed = path.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        guard !trimmed.isEmpty else {
            return ["/"]
        }

        var candidates: [String] = []
        let forms = [
            "/\(trimmed)/",
            "/\(trimmed)",
            "\(trimmed)/",
            trimmed,
        ]

        for candidate in forms where !candidates.contains(candidate) {
            candidates.append(candidate)
        }
        return candidates
    }

    private func normalizedDestination(
        from destination: String,
        siteBaseURL: String
    ) -> String {
        let trimmed = destination.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmed.isEmpty else {
            return normalizedAbsolutePath("/", siteBaseURL: siteBaseURL)
        }
        let lowercased = trimmed.lowercased()
        if lowercased.hasPrefix("http://") || lowercased.hasPrefix("https://") {
            return trimmed
        }
        let path = trimmed.hasPrefix("/") ? trimmed : "/\(trimmed)"
        return normalizedAbsolutePath(path, siteBaseURL: siteBaseURL)
    }

    private func normalizedAbsolutePath(
        _ path: String,
        siteBaseURL: String
    ) -> String {
        let normalizedBase =
            siteBaseURL.hasSuffix("/")
            ? String(siteBaseURL.dropLast()) : siteBaseURL
        let normalizedPath =
            path.hasPrefix("/") ? path : "/\(path)"
        return normalizedBase + normalizedPath
    }
}
