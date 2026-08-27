import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import AsyncHTTPClient
import BlogAdminAPI
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import FeatherAdmin
import WebAdminAPI
import AnalyticsAdminAPI
import RedirectAdminAPI

public struct AdminAPI: Sendable {

    private let blogClient: BlogAdminAPI.Client
    private let webClient: WebAdminAPI.Client
    let analyticsClient: AnalyticsAdminAPIClient
    let redirectClient: RedirectAdminAPIClient

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.blogClient = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(
                    client: .shared,
                    timeout: .seconds(3)
                )
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
        self.webClient = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(
                    client: .shared,
                    timeout: .seconds(3)
                )
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
        self.analyticsClient = .init(
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
        self.redirectClient = .init(
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func failure(
        statusCode: Int,
        responseBody: HTTPBody?
    ) async throws -> OpenAPIRepositoryError {
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }

    public func withBlogOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(blogClient)
        }
        catch let error as OpenAPIRepositoryError {
            throw error
        }
        catch {
            throw OpenAPIRepositoryError.transport(
                description: String(describing: error)
            )
        }
    }

    public func withWebOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (WebAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(webClient)
        }
        catch let error as OpenAPIRepositoryError {
            throw error
        }
        catch {
            throw OpenAPIRepositoryError.transport(
                description: String(describing: error)
            )
        }
    }

    private var unauthorizedMessage: String {
        "Please sign in again to load the admin dashboard."
    }
    private var forbiddenMessage: String {
        "Your account cannot access the admin dashboard."
    }

    func blogPostsTotal() async throws -> Int {
        try await self.withBlogOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func blogAuthorsTotal() async throws -> Int {
        try await self.withBlogOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func blogTagsTotal() async throws -> Int {
        try await self.withBlogOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func webPagesTotal() async throws -> Int {
        try await self.withWebOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func webMenusTotal() async throws -> Int {
        try await self.withWebOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func redirectRulesTotal() async throws -> Int {
        try await redirectClient.withOpenAPIRepositoryErrorMapping { client in
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
                throw try await self.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func webOverview(
        from: Double,
        to: Double
    ) async throws -> AdminGetHomeOverview {
        try await analyticsClient.withOpenAPIRepositoryErrorMapping { client in
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
                let overview = try okResponse.body.json
                return .init(
                    daily: overview.daily.map {
                        .init(bucket: $0.bucket, requests: $0.requests)
                    },
                    paths: overview.paths.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    },
                    browsers: overview.browsers.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    },
                    operatingSystems: overview.operatingSystems.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    },
                    deviceTypes: overview.deviceTypes.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    },
                    languages: overview.languages.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    },
                    regions: overview.regions.map {
                        .init(label: $0.label, count: $0.count, share: $0.share)
                    }
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: forbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await analyticsClient.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
