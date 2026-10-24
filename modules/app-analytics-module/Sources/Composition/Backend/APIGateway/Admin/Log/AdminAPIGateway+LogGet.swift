public import AnalyticsAdminAPI
import AnalyticsApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func analyticsLogGet(
        _ input: Operations.AnalyticsLogGet.Input
    ) async throws -> Operations.AnalyticsLogGet.Output {
        let useCase = useCases.makeLogDetail()
        let subject = try await CurrentSubject.require()
        let detail = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.id)
        )
        return .ok(
            .init(
                body: .json(map(detail))
            )
        )
    }

    private func map(
        _ detail: Log.Detail.Output
    ) -> Components.Schemas.AnalyticsLogDetailSchema {
        .init(
            id: detail.id,
            accountId: detail.accountId ?? "",
            source: detail.source,
            method: detail.method,
            url: detail.url,
            headers: detail.headers,
            ip: detail.ip ?? "",
            path: detail.path,
            referer: detail.referer ?? "",
            origin: detail.origin ?? "",
            acceptLanguage: detail.acceptLanguage ?? "",
            userAgent: detail.userAgent ?? "",
            language: detail.language ?? "",
            region: detail.region ?? "",
            osName: detail.osName ?? "",
            osVersion: detail.osVersion ?? "",
            browserName: detail.browserName ?? "",
            browserVersion: detail.browserVersion ?? "",
            engineName: detail.engineName ?? "",
            engineVersion: detail.engineVersion ?? "",
            deviceVendor: detail.deviceVendor ?? "",
            deviceType: detail.deviceType ?? "",
            deviceModel: detail.deviceModel ?? "",
            cpu: detail.cpu ?? "",
            responseCode: detail.responseCode,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }
}
