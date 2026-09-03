import AsyncHTTPClient
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import NIOCore
import NewsletterAdminAPI
import NewsletterAppAPI
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SGML
import WebStandards

public struct NewsletterAdminAPIClient: Sendable {
    public let client: NewsletterAdminAPI.Client

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
        _ operation: @Sendable (NewsletterAdminAPI.Client) async throws -> T
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

    public func newsletterCampaignTestEmail(
        path: NewsletterAdminAPI.Operations.NewsletterCampaignTestEmail.Input
            .Path,
        body: NewsletterAdminAPI.Components.RequestBodies
            .NewsletterIssueTestEmailRequestBody
    ) async throws
        -> NewsletterAdminAPI.Operations.NewsletterCampaignTestEmail.Output
    {
        try await client.newsletterCampaignTestEmail(path: path, body: body)
    }

    public func newsletterIssueTestEmail(
        path: NewsletterAdminAPI.Operations.NewsletterIssueTestEmail.Input.Path,
        body: NewsletterAdminAPI.Components.RequestBodies
            .NewsletterIssueTestEmailRequestBody
    ) async throws
        -> NewsletterAdminAPI.Operations.NewsletterIssueTestEmail.Output
    {
        try await client.newsletterIssueTestEmail(path: path, body: body)
    }
}

public struct NewsletterAppAPIClient: Sendable {
    public let client: NewsletterAppAPI.Client

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
        _ operation: @Sendable (NewsletterAppAPI.Client) async throws -> T
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
}

extension DefaultRequestContext {
    public func newsletterAdminAPI() -> NewsletterAdminAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func newsletterApplicationAPI() -> NewsletterAppAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
