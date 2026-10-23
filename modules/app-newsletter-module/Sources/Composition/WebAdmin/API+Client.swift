import AsyncHTTPClient
import FeatherWebAdmin
public import FeatherWebShared
public import Foundation
import NIOCore
public import NewsletterAdminAPI
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public struct NewsletterAdminAPIClient: Sendable {
    public let client: NewsletterAdminAPI.Client

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
        )
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (NewsletterAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do { return try await operation(client) }
        catch let error as OpenAPIRepositoryError { throw error }
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
        if statusCode == 409 { return .conflict }
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: try await responseBody?.collectString()
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
