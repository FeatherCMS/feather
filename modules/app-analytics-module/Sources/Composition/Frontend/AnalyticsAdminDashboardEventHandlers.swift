import AnalyticsAdminAPI
import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import SystemFrontend

public enum AnalyticsAdminDashboardEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminHomeOverviewProvider.self,
            context: AdminDashboardEventContext.self
        ) { _, context in
            guard context.permissions.contains("analytics:insights:list") else {
                return []
            }
            let api = AnalyticsAdminAPIClient(
                apiBaseURL: context.apiBaseURL,
                sessionToken: context.sessionToken
            )
            do {
                let overview = try await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    let response = try await client.analyticsLogOverview(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                source: "web_app",
                                from: context.from,
                                to: context.to
                            )
                        )
                    )
                    switch response {
                    case .ok(let value): return try value.body.json
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized(
                            message: unauthorizedMessage
                        )
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden(
                            message: forbiddenMessage
                        )
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
                return [
                    .init(
                        contentStats: [],
                        dailyTraffic: overview.daily.map {
                            .init(bucket: $0.bucket, requests: $0.requests)
                        },
                        topPages: overview.paths.map {
                            .init(
                                label: $0.label,
                                count: $0.count,
                                share: $0.share
                            )
                        },
                        insightCards: [
                            .init(
                                title: "Top pages",
                                items: overview.paths.prefix(8)
                                    .map {
                                        .init(
                                            label: $0.label,
                                            count: $0.count,
                                            share: $0.share
                                        )
                                    }
                            ),
                            .init(
                                title: "Operating systems",
                                items: overview.operatingSystems.map {
                                    .init(
                                        label: $0.label,
                                        count: $0.count,
                                        share: $0.share
                                    )
                                }
                            ),
                            .init(
                                title: "Browsers",
                                items: overview.browsers.map {
                                    .init(
                                        label: $0.label,
                                        count: $0.count,
                                        share: $0.share
                                    )
                                }
                            ),
                            .init(
                                title: "Device types",
                                items: overview.deviceTypes.map {
                                    .init(
                                        label: $0.label,
                                        count: $0.count,
                                        share: $0.share
                                    )
                                }
                            ),
                            .init(
                                title: "Languages",
                                items: overview.languages.map {
                                    .init(
                                        label: $0.label,
                                        count: $0.count,
                                        share: $0.share
                                    )
                                }
                            ),
                            .init(
                                title: "Regions",
                                items: overview.regions.map {
                                    .init(
                                        label: $0.label,
                                        count: $0.count,
                                        share: $0.share
                                    )
                                }
                            ),
                        ]
                    )
                ]
            }
            catch {
                return []
            }
        }
    }

    private static var unauthorizedMessage: String {
        "Please sign in again to load the admin dashboard."
    }
    private static var forbiddenMessage: String {
        "Your account cannot access the admin dashboard."
    }
}
