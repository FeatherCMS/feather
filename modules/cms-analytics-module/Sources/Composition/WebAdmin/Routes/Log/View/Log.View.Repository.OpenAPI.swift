import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Log.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Log.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.analyticsLogGet(
                    path: .init(id: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let schema = try okResponse.body.json
                    return .init(
                        id: schema.id,
                        accountId: schema.accountId,
                        source: schema.source,
                        method: schema.method,
                        url: schema.url,
                        headers: schema.headers,
                        ip: schema.ip,
                        path: schema.path,
                        referer: schema.referer,
                        origin: schema.origin,
                        acceptLanguage: schema.acceptLanguage,
                        userAgent: schema.userAgent,
                        language: schema.language,
                        region: schema.region,
                        osName: schema.osName,
                        osVersion: schema.osVersion,
                        browserName: schema.browserName,
                        browserVersion: schema.browserVersion,
                        engineName: schema.engineName,
                        engineVersion: schema.engineVersion,
                        deviceVendor: schema.deviceVendor,
                        deviceType: schema.deviceType,
                        deviceModel: schema.deviceModel,
                        cpu: schema.cpu,
                        responseCode: schema.responseCode,
                        createdAt: schema.createdAt,
                        updatedAt: schema.updatedAt
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
