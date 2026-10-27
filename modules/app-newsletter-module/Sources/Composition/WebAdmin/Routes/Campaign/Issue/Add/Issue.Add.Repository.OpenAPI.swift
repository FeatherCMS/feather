import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func createIssue(
            newsletterId: String,
            form: Issue.Form.Input,
            sendImmediately: Bool
        ) async throws
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterIssueCreate(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: .json(
                        .init(
                            subject: form.normalizedSubject,
                            content: form.content,
                            scheduledAt: sendImmediately
                                ? nil : form.scheduledAtTimestamp,
                            sendNow: sendImmediately
                        )
                    )
                )
                switch response {
                case .created: return
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
