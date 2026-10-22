import AsyncHTTPClient
public import FeatherWebShared
public import Foundation
import Hummingbird
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import WebAppAPI
import WebModuleWebShared

public enum WebApp {}

extension WebApp.API {
    public struct Client: Sendable {
        public let client: WebAppAPI.Client
        public let apiBaseURL: URL

        public init(
            apiBaseURL: URL,
            sessionToken: String? = nil
        ) {
            self.apiBaseURL = apiBaseURL
            self.client = .init(
                serverURL: apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                ),
                middlewares: [
                    WebAppAPIAuthMiddleware(sessionToken: sessionToken)
                ]
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (WebAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await WebAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                client,
                operation: operation
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await WebAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }

        public func resolveRouteReferenceID(
            path: String
        ) async throws -> String? {
            let response = try await client.webMetadataGet(
                path: .init(slug: path),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return try value.body.json.referenceId
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }

        public func publicMetadataSlugs() async throws -> [String] {
            let response = try await client.webMetadataList(
                .init(headers: .init(accept: [.init(contentType: .json)]))
            )
            switch response {
            case .ok(let value):
                return try value.body.json
            case .undocumented(let statusCode, let response):
                throw try await failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }

        public func publicSiteSettings() async throws
            -> WebAppAPI.Components.Schemas.WebSiteSettingsSchema
        {
            let response = try await client.webSiteSettings(.init())
            switch response {
            case .ok(let value):
                return try value.body.json
            case .undocumented(let statusCode, let response):
                throw try await failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private struct WebAppAPIAuthMiddleware: ClientMiddleware {
        let sessionToken: String?

        func intercept(
            _ request: HTTPRequest,
            body: HTTPBody?,
            baseURL: URL,
            operationID: String,
            next:
                @concurrent @Sendable (HTTPRequest, HTTPBody?, URL) async throws
                -> (
                    HTTPResponse, HTTPBody?
                )
        ) async throws -> (HTTPResponse, HTTPBody?) {
            var request = request
            if let sessionToken {
                request.headerFields[.authorization] = "Bearer \(sessionToken)"
            }
            return try await next(request, body, baseURL)
        }
    }
}
