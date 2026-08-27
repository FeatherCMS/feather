import BlogAdminAPI
import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import SystemFrontend

public enum BlogAdminDashboardEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminHomeOverviewProvider.self,
            context: AdminDashboardEventContext.self
        ) { _, context in
            let api = BlogAdminAPIClient(
                apiBaseURL: context.apiBaseURL,
                sessionToken: context.sessionToken
            )
            var contentStats: [AdminGetHomeModel.ContentStat] = []

            await appendCount(
                label: "Blog posts",
                permission: "blog:posts:list",
                permissions: context.permissions,
                operation: {
                    try await countPosts(using: api)
                },
                to: &contentStats
            )
            await appendCount(
                label: "Blog authors",
                permission: "blog:authors:list",
                permissions: context.permissions,
                operation: {
                    try await countAuthors(using: api)
                },
                to: &contentStats
            )
            await appendCount(
                label: "Blog tags",
                permission: "blog:tags:list",
                permissions: context.permissions,
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

    private static func countPosts(using api: BlogAdminAPIClient) async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(page: .init(size: 1, number: 1), filters: .init(search: nil)))
            )
            switch response {
            case .ok(let value): return try value.body.json.data.total
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: unauthorizedMessage)
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: forbiddenMessage)
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    private static func countAuthors(using api: BlogAdminAPIClient) async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(page: .init(size: 1, number: 1), filters: .init(search: nil)))
            )
            switch response {
            case .ok(let value): return try value.body.json.data.total
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: unauthorizedMessage)
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: forbiddenMessage)
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    private static func countTags(using api: BlogAdminAPIClient) async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(page: .init(size: 1, number: 1), filters: .init(search: nil)))
            )
            switch response {
            case .ok(let value): return try value.body.json.data.total
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: unauthorizedMessage)
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: forbiddenMessage)
            case .undocumented(let statusCode, let response):
                throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    private static var unauthorizedMessage: String { "Please sign in again to load the admin dashboard." }
    private static var forbiddenMessage: String { "Your account cannot access the admin dashboard." }

    private static func appendCount(
        label: String,
        permission: String,
        permissions: Set<String>,
        operation: @escaping @Sendable () async throws -> Int,
        to contentStats: inout [AdminGetHomeModel.ContentStat]
    ) async {
        guard permissions.contains(permission), let count = try? await operation() else { return }
        contentStats.append(.init(label: label, value: "\(count)"))
    }
}
