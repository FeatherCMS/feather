public import FeatherWebApp
import Foundation
import HTTPTypes
public import Hummingbird
import Logging

public struct RedirectRuleMiddleware: RouterMiddleware {

    public let siteBaseURL: String
    private let resolver: any RedirectRuleResolver

    public init(
        siteBaseURL: String,
        resolver: any RedirectRuleResolver
    ) {
        self.siteBaseURL = siteBaseURL
        self.resolver = resolver
    }

    public func handle(
        _ request: Request,
        context: DefaultRequestContext,
        next:
            @concurrent (Request, DefaultRequestContext) async throws ->
            Response
    ) async throws -> Response {
        // Resolve the URL first so a matching content page wins over a redirect.
        let response = try await next(request, context)
        let path = request.uri.path
        guard
            resolver.shouldLookupRedirect(
                path: path,
                method: request.method.rawValue,
                responseCode: Int(response.status.code)
            )
        else {
            return response
        }

        let rule: ResolvedRedirect?
        do {
            rule = try await resolver.resolveRedirect(
                source: normalizedRedirectSource(for: path)
            )
        }
        catch {
            context.logger.error("Redirect rule lookup failed: \(error)")
            return response
        }
        guard let rule else { return response }

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

    private func normalizedRedirectSource(
        for path: String
    ) -> String {
        guard !path.isEmpty else { return "/" }
        return path.hasPrefix("/") ? path : "/\(path)"
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
