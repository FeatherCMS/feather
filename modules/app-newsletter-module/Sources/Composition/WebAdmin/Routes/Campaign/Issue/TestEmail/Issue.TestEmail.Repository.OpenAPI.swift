import FeatherWebShared
import NewsletterAdminAPI

extension Issue.TestEmail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func send(
            newsletterKey: String,
            issueID: String?,
            email: String,
            subject: String,
            content: String
        ) async throws {
            let body = Components.RequestBodies
                .NewsletterIssueTestEmailRequestBody.json(
                    .init(email: email, subject: subject, content: content)
                )

            try await api.withOpenAPIRepositoryErrorMapping { client in
                if let issueID {
                    let response = try await client.newsletterIssueTestEmail(
                        path: .init(
                            newsletterCampaignKey: newsletterKey,
                            newsletterIssueId: issueID
                        ),
                        body: body
                    )
                    switch response {
                    case .noContent:
                        return
                    case .notFound:
                        throw OpenAPIRepositoryError.notFound
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }

                let response = try await client.newsletterCampaignTestEmail(
                    path: .init(newsletterCampaignKey: newsletterKey),
                    body: body
                )
                switch response {
                case .noContent:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
