import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension NotFound.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func getOverview(
            from: Double,
            to: Double
        ) async throws -> Overview.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.analyticsLogOverview(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            source: "web_app",
                            from: from,
                            to: to,
                            notFoundOnly: true
                        )
                    )
                )

                switch response {
                case .ok(let okResponse):
                    let schema = try okResponse.body.json
                    return Overview.Model(
                        query: .init(
                            from: schema.query.from,
                            to: schema.query.to
                        ),
                        kpis: .init(
                            totalRequests: schema.kpis.totalRequests,
                            averageRequestsPerDay:
                                schema.kpis.averageRequestsPerDay,
                            authenticatedRequests:
                                schema.kpis.authenticatedRequests,
                            notFoundRequests: schema.kpis.notFoundRequests,
                            clientErrorRequests:
                                schema.kpis.clientErrorRequests,
                            serverErrorRequests:
                                schema.kpis.serverErrorRequests,
                            pageViews: schema.kpis.pageViews,
                            searchRequests: schema.kpis.searchRequests,
                            botRequests: schema.kpis.botRequests,
                            aiRequests: schema.kpis.aiRequests,
                            humanRequests: schema.kpis.humanRequests,
                            uniqueVisitors: schema.kpis.uniqueVisitors
                        ),
                        daily: schema.daily.map {
                            .init(
                                bucket: $0.bucket,
                                requests: $0.requests,
                                notFoundRequests: $0.notFoundRequests,
                                clientErrorRequests: $0.clientErrorRequests,
                                serverErrorRequests: $0.serverErrorRequests
                            )
                        },
                        methods: [],
                        paths: [],
                        notFoundPaths: schema.notFoundPaths.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        serverErrorPaths: [],
                        referrers: [],
                        browsers: [],
                        operatingSystems: [],
                        deviceTypes: [],
                        languages: [],
                        regions: []
                    )
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
