import BlogAdminAPI
import FeatherWebShared
public import FeatherWebAdmin
public import FeatherModuleKit
import OpenAPIRuntime
import SystemModule
import SystemWebAdmin

public enum BlogAdminDashboardEventHandlers {
    public static func register(
        in events: inout EventRegistry,
        environment: AppEnvironment
    ) {
        let apiBuilder = BlogAPIBuilder(apiBaseURL: environment.apiBaseURL)
        events.register(
            event: SystemWebAdmin.Dashboard.Event.Provider.self,
            context: SystemWebAdmin.Dashboard.Event.Context.self
        ) { _, context in
            let api = apiBuilder.makeBlogAdmin(context.requestContext)
            var contentStats: [SystemWebAdmin.Dashboard.Model.ContentStat] = []

            await appendCount(
                label: "Blog posts",
                permission: "blog:posts:list",
                permissions: context.requestContext.currentUserPermissions,
                operation: {
                    try await countPosts(using: api)
                },
                to: &contentStats
            )
            await appendCount(
                label: "Blog authors",
                permission: "blog:authors:list",
                permissions: context.requestContext.currentUserPermissions,
                operation: {
                    try await countAuthors(using: api)
                },
                to: &contentStats
            )
            await appendCount(
                label: "Blog tags",
                permission: "blog:tags:list",
                permissions: context.requestContext.currentUserPermissions,
                operation: {
                    try await countTags(using: api)
                },
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

    private static func countPosts(using api: BlogAdminAPIClient) async throws
        -> Int
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostSearch(
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

    private static func countAuthors(using api: BlogAdminAPIClient) async throws
        -> Int
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorSearch(
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

    private static func countTags(using api: BlogAdminAPIClient) async throws
        -> Int
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagSearch(
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
        to contentStats: inout [SystemWebAdmin.Dashboard.Model.ContentStat]
    ) async {
        guard permissions.contains(permission),
            let count = try? await operation()
        else { return }
        contentStats.append(.init(label: label, value: "\(count)"))
    }
}
