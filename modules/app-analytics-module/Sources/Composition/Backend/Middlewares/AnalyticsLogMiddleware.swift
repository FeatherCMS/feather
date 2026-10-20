import AnalyticsApplication
import AnalyticsDomain
import HTTPTypes
public import Hummingbird

public struct AnalyticsLogMiddleware: RouterMiddleware {

    private static let forwardedFor = HTTPField.Name("x-forwarded-for")!
    private let analytics: AnalyticsBackend.UseCases
    private let resolveAccountID: @Sendable (Request) async -> String?

    public init(
        analytics: AnalyticsBackend.UseCases,
        resolveAccountID: @escaping @Sendable (Request) async -> String?
    ) {
        self.analytics = analytics
        self.resolveAccountID = resolveAccountID
    }

    public func handle(
        _ request: Request,
        context: BasicRequestContext,
        next:
            @concurrent (Request, BasicRequestContext) async throws -> Response
    ) async throws -> Response {
        let path = request.uri.path
        let url = request.uri.description
        let method = request.method.rawValue
        let response = try await next(request, context)
        let responseCode = Int(response.status.code)
        guard
            shouldTrack(
                path: path,
                method: method,
                responseCode: responseCode
            )
        else {
            return response
        }

        let useCase = analytics.makeTrackLog()
        let accountId = await resolveAccountID(request)
        let headers = Self.storedHeaders(from: request)
        let headersString = AnalyticsLogRequestMetadata.headersJSONString(
            headers
        )
        let acceptLanguage = request.headers[.acceptLanguage]
        let userAgent = request.headers[.userAgent]
        let languageComponents =
            AnalyticsLogRequestMetadata
            .parseAcceptLanguage(acceptLanguage)
        let userAgentComponents =
            AnalyticsLogRequestMetadata
            .parseUserAgent(userAgent)

        do {
            _ = try await useCase.execute(
                input: .init(
                    accountId: accountId,
                    source: .backendAPI,
                    method: method,
                    url: url,
                    headers: headersString,
                    ip: request.headers[Self.forwardedFor],
                    path: path,
                    referer: request.headers[.referer],
                    origin: request.headers[.origin],
                    acceptLanguage: acceptLanguage,
                    userAgent: userAgent,
                    language: languageComponents.language,
                    region: languageComponents.region,
                    osName: userAgentComponents.osName,
                    osVersion: userAgentComponents.osVersion,
                    browserName: userAgentComponents.browserName,
                    browserVersion: userAgentComponents.browserVersion,
                    engineName: userAgentComponents.engineName,
                    engineVersion: userAgentComponents.engineVersion,
                    deviceVendor: userAgentComponents.deviceVendor,
                    deviceType: userAgentComponents.deviceType,
                    deviceModel: userAgentComponents.deviceModel,
                    cpu: userAgentComponents.cpu,
                    responseCode: responseCode
                )
            )
        }
        catch {
            // print("Analytics tracking failed: \(error)")
        }

        return response
    }

    private func shouldTrack(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        let lowercasedPath = path.lowercased()
        if Self.isIgnoredPath(lowercasedPath) {
            return false
        }
        if lowercasedPath.hasPrefix("/api/v1/admin/analytics/") {
            return false
        }
        if lowercasedPath == "/api/v1/analytics/logs/track" {
            return false
        }
        if Self.isStaticAsset(lowercasedPath) {
            return false
        }

        // Public page visits are tracked by the web app middleware. Keep API
        // failures and successful state-changing requests here, but skip the
        // high-volume successful API reads and preflight checks.
        return responseCode >= 400
            || (300..<400).contains(responseCode)
            || ["POST", "PUT", "PATCH", "DELETE"].contains(method)
    }

    private static func storedHeaders(from request: Request) -> [String: String] {
        let allowedNames: Set<String> = ["accept", "content-type"]
        return request.headers.reduce(into: [String: String]()) {
            result,
            field in
            let name = field.name.rawName.lowercased()
            guard allowedNames.contains(name) else { return }
            result[name] = String(field.value.prefix(256))
        }
    }

    private static func isStaticAsset(_ path: String) -> Bool {
        [
            ".css", ".js", ".mjs", ".map", ".png", ".jpg", ".jpeg",
            ".gif", ".svg", ".webp", ".ico", ".woff", ".woff2",
            ".ttf", ".eot", ".avif",
        ].contains { path.hasSuffix($0) }
    }

    private static func isIgnoredPath(_ path: String) -> Bool {
        if path == "/health" || path == "/robots.txt" || path == "/favicon.ico" {
            return true
        }
        return [
            "/.env", "/.git", "/.svn", "/wp-", "/wp/", "/wordpress",
            "/xmlrpc.php", "/phpmyadmin", "/cgi-bin/",
        ].contains { path.contains($0) }
    }
}
