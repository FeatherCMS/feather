import Application
import AnalyticsApplication
import AnalyticsDomain
import AppOpenAPI

extension AppAPI {

    func analyticsLogTrack(
        _ input: Operations.AnalyticsLogTrack.Input
    ) async throws -> Operations.AnalyticsLogTrack.Output {
        let body: Components.Schemas.AppAnalyticsLogTrackSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let accountId = await CurrentSubject.get()?.id
        let languageComponents =
            AnalyticsLogRequestMetadata
            .parseAcceptLanguage(body.acceptLanguage)
        let userAgentComponents =
            AnalyticsLogRequestMetadata
            .parseUserAgent(body.userAgent)

        _ = try await modules.analytics.makeTrackLog()
            .execute(
                input: .init(
                    accountId: accountId,
                    source: .webApp,
                    method: body.method,
                    url: body.url,
                    headers: body.headers,
                    ip: body.ip.isEmpty ? nil : body.ip,
                    path: body.path,
                    referer: body.referer.isEmpty ? nil : body.referer,
                    origin: body.origin.isEmpty ? nil : body.origin,
                    acceptLanguage: body.acceptLanguage.isEmpty
                        ? nil
                        : body.acceptLanguage,
                    userAgent: body.userAgent.isEmpty ? nil : body.userAgent,
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
                    responseCode: body.responseCode
                )
            )

        return .noContent
    }
}
