import AsyncHTTPClient
import FeatherAdmin
import Foundation
import MediaFrontend
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import WebAdminAPI
import WebAppAPI

public struct WebAdminAPIClient: Sendable {
    public let client: WebAdminAPI.Client
    public let sessionToken: String?

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.sessionToken = sessionToken
        self.client = .init(
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
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (WebAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(client)
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

    public func mediaAdminAPI() -> MediaAdminAPIClient {
        .init(
            apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}

public struct WebAppAPIClient: Sendable {
    public let client: WebAppAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.client = .init(
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
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (WebAppAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(client)
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
}

extension DefaultRequestContext {
    public func webAdminAPI() -> WebAdminAPIClient {
        .init(
            apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func webApplicationAPI() -> WebAppAPIClient {
        .init(
            apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
