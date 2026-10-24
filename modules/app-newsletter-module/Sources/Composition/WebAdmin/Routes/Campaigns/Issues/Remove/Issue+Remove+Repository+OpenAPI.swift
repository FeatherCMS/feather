import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Issue.Remove {
    enum Repository {}
}

extension Issue.Remove.Repository {
    struct OpenAPI {
        let api: API.Client

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model {
            try await Issue.Edit.Repository.OpenAPI(api: api)
                .get(newsletterId: newsletterId, issueId: issueId)
        }

        func remove(newsletterId: String, issueId: String) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterIssueRemove(
                    path: .init(newsletterCampaignKey: newsletterId),
                    body: .json(.init(ids: [issueId]))
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
