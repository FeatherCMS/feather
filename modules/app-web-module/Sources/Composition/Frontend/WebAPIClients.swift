import AsyncHTTPClient
public import FeatherAdmin
public import Foundation
public import MediaFrontend
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import WebAdminAPI
public import WebAppAPI
public import SystemFrontend

public struct WebAdminAPIClient: Sendable {
    public let client: WebAdminAPI.Client
    public let sessionToken: String?
    public let apiBaseURL: URL

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.apiBaseURL = apiBaseURL
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
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
    }
}

public struct WebAppAPIClient: Sendable {
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

public struct WebAPIBuilder: Sendable {
    private let apiBaseURL: URL
    public let media: MediaAPIBuilder
    public let system: SystemAPIBuilder

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
        self.media = .init(apiBaseURL: apiBaseURL)
        self.system = .init(apiBaseURL: apiBaseURL)
    }

    public var baseURL: URL { apiBaseURL }

    public func makeWebAdmin(
        _ context: AuthenticatedRequestContext
    ) -> WebAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeWebApp(
        _ context: DefaultRequestContext
    ) -> WebAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeMediaAdmin(
        _ context: AuthenticatedRequestContext
    ) -> MediaAdminAPIClient {
        media.makeMediaAdmin(context)
    }

    public func makeSystemAdmin(
        _ context: AuthenticatedRequestContext
    ) -> SystemAdminAPIClient {
        system.makeSystemAdmin(context)
    }
}
