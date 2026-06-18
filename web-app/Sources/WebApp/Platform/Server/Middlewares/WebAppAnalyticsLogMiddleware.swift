import AppOpenAPI
import Foundation
import HTTPTypes
import Hummingbird

struct WebAppAnalyticsLogMiddleware: RouterMiddleware {

    let apiBaseURL: URL

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: @concurrent (Request, AppRequestContext) async throws -> Response
    ) async throws -> Response {
        let path = request.uri.path
        let response = try await next(request, context)
        let responseCode = Int(response.status.code)
        guard shouldTrack(path: path, responseCode: responseCode) else {
            return response
        }

        let sessionToken = request.cookies["session_token"]?.value
        let method = request.method.rawValue
        let url = request.uri.description
        let ip = request.headers[HTTPField.Name("x-forwarded-for")!]
        let referer = request.headers[.referer]
        let origin = request.headers[.origin]
        let acceptLanguage = request.headers[.acceptLanguage]
        let userAgent = request.headers[.userAgent]
        let headers = request.headers.reduce(into: [String: String]()) {
            result,
            field in
            result[field.name.rawName.lowercased()] = field.value
        }
        let headersString = headersJSONString(headers)

        Task.detached {
            let api = ApplicationAPI(
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
        responseCode: Int
    ) -> Bool {
        if path == "/health" {
            return false
        }
        if responseCode == 404 {
            return true
        }
        if path == "/admin-navigation.js" {
            return false
        }
        if path.hasPrefix("/images/") {
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

    private func headersJSONString(
        _ headers: [String: String]
    ) -> String {
        let headersData =
            (try? JSONSerialization.data(withJSONObject: headers))
            ?? Data("{}".utf8)
        return String(data: headersData, encoding: .utf8) ?? "{}"
    }
}
