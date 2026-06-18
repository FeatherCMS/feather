import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetHomeOpenAPIRepository: AdminGetHomeRepository {
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to load the admin dashboard."
    private let forbiddenMessage =
        "Your account cannot access the admin dashboard."

    func blogPostsTotal() async throws -> Int {
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
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func blogAuthorsTotal() async throws -> Int {
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
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func blogTagsTotal() async throws -> Int {
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
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func webPagesTotal() async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webPageSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 1, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func webMenusTotal() async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 1, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func redirectRulesTotal() async throws -> Int {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 1, number: 1),
                        filters: .init(search: nil, statusCode: nil)
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json.data.total
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
    }

    func webOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.analyticsLogOverview(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        source: "web_app",
                        from: from,
                        to: to
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json
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
    }
}
