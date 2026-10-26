import AnalyticsApplication
import AnalyticsDomain
public import AnalyticsModule
import Foundation
import HTTPTypes
public import Hummingbird

public struct AnalyticsLogMiddleware: RouterMiddleware {

    private static let forwardedFor = HTTPField.Name("x-forwarded-for")!
    private let analytics: AnalyticsBackend.UseCases
    private let resolveAccountID: @Sendable (Request) async -> String?
    private let logFilter: any Log.Filter.Interface

    public init(
        analytics: AnalyticsBackend.UseCases,
        resolveAccountID: @escaping @Sendable (Request) async -> String?,
        logFilter: any Log.Filter.Interface
    ) {
        self.analytics = analytics
        self.resolveAccountID = resolveAccountID
        self.logFilter = logFilter
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
            logFilter.shouldTrack(
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
                    headers: headers,
                    ip: request.headers[Self.forwardedFor],
                    path: path,
                    referer: request.headers[.referer],
                    origin: request.headers[.origin],
                    acceptLanguage: acceptLanguage,
                    userAgent: userAgent,
                    trafficCategory:
                        AnalyticsLogRequestMetadata.classifyUserAgent(
                            userAgent
                        ),
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
