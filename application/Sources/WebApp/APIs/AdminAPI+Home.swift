import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import AnalyticsAdminAPI
import BlogAdminAPI
import Foundation
import Hummingbird
import OpenAPIRuntime
import RedirectAdminAPI
import WebAdminAPI

extension AdminAPI {
    private var api: AdminAPI { self }
    private var analyticsAPI: AnalyticsAdminAPIClient {
        analyticsClient
    }
    private var redirectAPI: RedirectAdminAPIClient {
        redirectClient
    }
    private var unauthorizedMessage: String {
        "Please sign in again to load the admin dashboard."
    }
    private var forbiddenMessage: String {
        "Your account cannot access the admin dashboard."
    }

    func blogPostsTotal() async throws -> Int {
        try await api.withBlogOpenAPIRepositoryErrorMapping { client in
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
        try await api.withBlogOpenAPIRepositoryErrorMapping { client in
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
        try await api.withBlogOpenAPIRepositoryErrorMapping { client in
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
        try await api.withWebOpenAPIRepositoryErrorMapping { client in
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
        try await api.withWebOpenAPIRepositoryErrorMapping { client in
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
        try await redirectAPI.withOpenAPIRepositoryErrorMapping { client in
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
    ) async throws -> AdminGetHomeOverview {
        try await analyticsAPI.withOpenAPIRepositoryErrorMapping { client in
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
                throw try await analyticsAPI.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
