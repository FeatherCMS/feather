import AnalyticsAppAPI
public import FeatherAdmin
public import Foundation
import HTTPTypes
public import Hummingbird

public struct WebAppAnalyticsLogMiddleware: RouterMiddleware {

    public let apiBaseURL: URL

    public init(
        apiBaseURL: URL
    ) {
        self.apiBaseURL = apiBaseURL
    }

    public func handle(
        _ request: Request,
        context: DefaultRequestContext,
        next:
            @concurrent (Request, DefaultRequestContext) async throws ->
            Response
    ) async throws -> Response {
        let path = request.uri.path
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

        let sessionToken = request.cookies["session_token"]?.value
        let url = request.uri.description
        let ip = request.headers[HTTPField.Name("x-forwarded-for")!]
        let referer = request.headers[.referer]
        let origin = request.headers[.origin]
        let acceptLanguage = request.headers[.acceptLanguage]
        let userAgent = request.headers[.userAgent]
        let headers = storedHeaders(from: request)
        let headersString = headersJSONString(headers)

        Task.detached {
            let api = AnalyticsAppAPIClient(
                apiBaseURL: apiBaseURL,
                sessionToken: sessionToken
            )
            let payload = Components.Schemas.AppAnalyticsLogTrackSchema(
                method: method,
                url: url,
                headers: headersString,
                ip: ip ?? "",
                path: path,
                referer: referer ?? "",
                origin: origin ?? "",
                acceptLanguage: acceptLanguage ?? "",
                userAgent: userAgent ?? "",
                responseCode: responseCode
            )
            let requestBody:
                Components.RequestBodies
                    .AnalyticsLogTrackRequestBody = .json(
                        payload
                    )
            do {
                _ = try await api.withOpenAPIRepositoryErrorMapping { client in
                    try await client.analyticsLogTrack(body: requestBody)
                }
            }
            catch {
                print("Web app analytics tracking failed: \(error)")
            }
        }

        return response
    }

    private func shouldTrack(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool {
        let lowercasedPath = path.lowercased()
        if isIgnoredPath(lowercasedPath) {
            return false
        }
        if isStaticAsset(lowercasedPath) {
            return false
        }

        // Successful page visits remain useful. Skip successful background,
        // preflight, and write requests; API writes are recorded by the backend.
        if responseCode >= 400 {
            return true
        }
        return method == "GET" && responseCode < 400
    }

    private func storedHeaders(from request: Request) -> [String: String] {
        let allowedNames: Set<String> = ["accept", "content-type"]
        return request.headers.reduce(into: [String: String]()) {
            result,
            field in
            let name = field.name.rawName.lowercased()
            guard allowedNames.contains(name) else { return }
            result[name] = String(field.value.prefix(256))
        }
    }

    private func headersJSONString(_ headers: [String: String]) -> String {
        let headersData =
            (try? JSONSerialization.data(withJSONObject: headers))
            ?? Data("{}".utf8)
        return String(data: headersData, encoding: .utf8) ?? "{}"
    }

    private func isStaticAsset(_ path: String) -> Bool {
        [
            ".css", ".js", ".mjs", ".map", ".png", ".jpg", ".jpeg",
            ".gif", ".svg", ".webp", ".ico", ".woff", ".woff2",
            ".ttf", ".eot", ".avif",
        ].contains { path.hasSuffix($0) }
    }

    private func isIgnoredPath(_ path: String) -> Bool {
        if path == "/health" || path == "/robots.txt" || path == "/favicon.ico" {
            return true
        }
        return [
            "/.env", "/.git", "/.svn", "/wp-", "/wp/", "/wordpress",
            "/xmlrpc.php", "/phpmyadmin", "/cgi-bin/",
        ].contains { path.contains($0) }
    }
}
