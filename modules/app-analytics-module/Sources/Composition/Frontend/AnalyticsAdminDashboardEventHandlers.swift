import AnalyticsAdminAPI
public import FeatherAdmin
public import FeatherModuleKit
import OpenAPIRuntime
import SystemModule
import SystemWebAdmin

public enum AnalyticsAdminDashboardEventHandlers {
    public static func register(
        in events: inout EventRegistry,
        environment: AppEnvironment
    ) {
        let apiBuilder = AnalyticsAPIBuilder(apiBaseURL: environment.apiBaseURL)
        events.register(
            event: SystemWebAdmin.Dashboard.Event.Provider.self,
            context: SystemWebAdmin.Dashboard.Event.Context.self
        ) { _, context in
            guard
                context.requestContext.currentUserPermissions.contains(
                    "analytics:insights:list"
                )
            else {
                return []
            }
            let api = apiBuilder.makeAnalyticsAdmin(context.requestContext)
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
