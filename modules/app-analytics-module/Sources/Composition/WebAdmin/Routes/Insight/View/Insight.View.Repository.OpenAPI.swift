import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Insight.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func getOverview(
            source: String,
            from: Double,
            to: Double
        ) async throws -> Overview.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.analyticsLogOverview(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            source: source,
                            from: from,
                            to: to
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
                        methods: schema.methods.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        paths: schema.paths.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        notFoundPaths: schema.notFoundPaths.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        serverErrorPaths: schema.serverErrorPaths.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        referrers: schema.referrers.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        browsers: schema.browsers.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        operatingSystems: schema.operatingSystems.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        deviceTypes: schema.deviceTypes.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        languages: schema.languages.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        regions: schema.regions.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        }
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
