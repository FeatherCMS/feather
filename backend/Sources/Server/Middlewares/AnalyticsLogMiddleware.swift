import Application
import AnalyticsApplication
import AnalyticsDomain
import AuthApplication
import Foundation
import Hummingbird
import HTTPTypes

struct AnalyticsLogMiddleware: RouterMiddleware {

    private static let forwardedFor = HTTPField.Name("x-forwarded-for")!
    private static let sessionCookieName = "session"

    let modules: AppModules

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

        let useCase = modules.analytics.makeTrackLog()
        let accountId = await resolveAccountID(from: request)
        let headers = request.headers.reduce(into: [String: String]()) {
            result,
            field in
            result[field.name.rawName.lowercased()] = field.value
        }
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
                    method: request.method.rawValue,
                    url: request.uri.description,
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
            print("Analytics tracking failed: \(error)")
        }

        return response
    }

    private func resolveAccountID(
        from request: Request
    ) async -> String? {
        guard let token = resolveAuthToken(from: request) else {
            return nil
        }
        let useCase = modules.auth.makeTokenAuth()
        return try? await useCase.execute(.init(token: token))?.accountId
    }

    private func resolveAuthToken(
        from request: Request
    ) -> String? {
        let cookies = request.headers[.cookie].map { Cookies(from: [$0]) }
        if let token = cookies?[Self.sessionCookieName]?.value, !token.isEmpty {
            return token
        }
        if let bearerToken = request.headers[.authorization] {
            let prefix = "Bearer "
            if bearerToken.hasPrefix(prefix) {
                let token = String(bearerToken.dropFirst(prefix.count))
                if !token.isEmpty {
                    return token
                }
            }
        }
        return nil
    }

    private func shouldTrack(
        path: String,
        responseCode: Int
    ) -> Bool {
        if path == "/health" {
            return false
        }
        if path.hasPrefix("/api/v1/admin/analytics/") {
            return false
        }
        if path == "/api/v1/analytics/logs/track" {
            return false
        }
        if responseCode == 404 {
            return true
        }
        return true
    }
}
