import AnalyticsAppAPI
public import AnalyticsModule
public import FeatherWebShared
public import Foundation
import HTTPTypes
public import Hummingbird

public struct WebAppAnalyticsLogMiddleware: RouterMiddleware {

    public let apiBaseURL: URL
    private let logFilter: any Log.Filter.Interface

    public init(
        apiBaseURL: URL,
        logFilter: any Log.Filter.Interface
    ) {
        self.apiBaseURL = apiBaseURL
        self.logFilter = logFilter
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
            logFilter.shouldTrack(
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
        let headers = Self.storedHeaders(from: request)
        Task.detached {
            let api = AnalyticsAppAPIClient(
                apiBaseURL: apiBaseURL,
                sessionToken: sessionToken
            )
            let payload = Components.Schemas.AppAnalyticsLogTrackSchema(
                method: method,
                url: url,
                headers: headers,
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

    private static func storedHeaders(from request: Request) -> String {
        let allowedNames: Set<String> = ["accept", "content-type"]
        let headers = request.headers.reduce(into: [String: String]()) {
            result,
            field in
            let name = field.name.canonicalName
            guard allowedNames.contains(name) else { return }
            result[name] = String(field.value.prefix(256))
        }
        guard
            let data = try? JSONEncoder().encode(headers),
            let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return json
    }

}
