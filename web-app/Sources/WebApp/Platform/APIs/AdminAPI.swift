import AdminOpenAPI
import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

struct AdminAPI {

    private let apiBaseURL: URL
    private let client: Client

    init(
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

    func contactFieldList() async throws -> Operations.ContactFieldList.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactFieldList()
        }
    }

    func contactFieldCreate(
        body: Components.RequestBodies.ContactFormItemCreateRequestBody
    ) async throws -> Operations.ContactFieldCreate.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactFieldCreate(body: body)
        }
    }

    func contactFieldGet(
        path: Operations.ContactFieldGet.Input.Path
    ) async throws -> Operations.ContactFieldGet.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactFieldGet(path: path)
        }
    }

    func contactFieldUpdate(
        path: Operations.ContactFieldUpdate.Input.Path,
        body: Components.RequestBodies.ContactFormItemPatchRequestBody
    ) async throws -> Operations.ContactFieldUpdate.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactFieldUpdate(path: path, body: body)
        }
    }

    func contactFieldDelete(
        path: Operations.ContactFieldDelete.Input.Path
    ) async throws -> Operations.ContactFieldDelete.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactFieldDelete(path: path)
        }
    }

    func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (Client) async throws -> T
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

    func failure(
        statusCode: Int,
        responseBody: HTTPBody?
    ) async throws -> OpenAPIRepositoryError {
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }

    func contactNewsletterIssueGet(
        path: Operations.ContactNewsletterIssueGet.Input.Path
    ) async throws -> Operations.ContactNewsletterIssueGet.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactNewsletterIssueGet(path: path)
        }
    }

    func contactNewsletterIssueUpdate(
        path: Operations.ContactNewsletterIssueUpdate.Input.Path,
        body: Components.RequestBodies.ContactNewsletterIssuePatchRequestBody
    ) async throws -> Operations.ContactNewsletterIssueUpdate.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactNewsletterIssueUpdate(
                path: path,
                body: body
            )
        }
    }

    func contactNewsletterIssueDelete(
        path: Operations.ContactNewsletterIssueDelete.Input.Path
    ) async throws -> Operations.ContactNewsletterIssueDelete.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactNewsletterIssueDelete(path: path)
        }
    }

    func contactNewsletterTestEmail(
        path: Operations.ContactNewsletterTestEmail.Input.Path,
        body: Components.RequestBodies
            .ContactNewsletterIssueTestEmailRequestBody
    ) async throws -> Operations.ContactNewsletterTestEmail.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactNewsletterTestEmail(path: path, body: body)
        }
    }

    func contactNewsletterIssueTestEmail(
        path: Operations.ContactNewsletterIssueTestEmail.Input.Path,
        body: Components.RequestBodies
            .ContactNewsletterIssueTestEmailRequestBody
    ) async throws -> Operations.ContactNewsletterIssueTestEmail.Output {
        try await withOpenAPIRepositoryErrorMapping { client in
            try await client.contactNewsletterIssueTestEmail(
                path: path,
                body: body
            )
        }
    }
}
