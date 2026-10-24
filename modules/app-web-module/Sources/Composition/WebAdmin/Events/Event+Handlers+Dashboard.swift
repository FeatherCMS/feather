public import FeatherModuleKit
import FeatherWebAdmin
public import FeatherWebShared
import OpenAPIRuntime
import SystemModule
import SystemWebAdmin
import WebAdminAPI
public import WebModule

extension WebModule.Event.Handlers {
    public static func registerDashboard(
        in events: inout EventRegistry,
        environment: AppEnvironment
    ) {
        events.register(
            event: SystemWebAdmin.Dashboard.Event.Provider.self,
            context: SystemWebAdmin.Dashboard.Event.Context.self
        ) { _, context in
            let api = API.Client(
                environment: environment,
                requestContext: context.requestContext
            )
            var contentStats:
                [SystemWebAdmin.Dashboard.Model
                    .ContentStat] = []

            await appendCount(
                label: "Web pages",
                permission: "web:pages:list",
                permissions: context.requestContext.currentUserPermissions,
                operation: { try await countPages(using: api) },
                to: &contentStats
            )
            return [
                .init(
                    contentStats: contentStats,
                    dailyTraffic: nil,
                    topPages: nil,
                    insightCards: []
                )
            ]
        }
    }

    private static func countPages(using api: API.Client) async throws
        -> Int
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.pageQuery(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 1, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )
            switch response {
            case .ok(let value): return try value.body.json.data.total
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

    private static var unauthorizedMessage: String {
        "Please sign in again to load the admin dashboard."
    }
    private static var forbiddenMessage: String {
        "Your account cannot access the admin dashboard."
    }

    private static func appendCount(
        label: String,
        permission: String,
        permissions: Set<String>,
        operation: @escaping @Sendable () async throws -> Int,
        to contentStats:
            inout [SystemWebAdmin.Dashboard.Model
            .ContentStat]
    ) async {
        guard permissions.contains(permission),
            let count = try? await operation()
        else { return }
        contentStats.append(.init(label: label, value: "\(count)"))
    }
}
