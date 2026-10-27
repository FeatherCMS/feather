import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Issue.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterIssueGet(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
                        newsletterIssueId: issueId
                    )
                )
                switch response {
                case .ok(let value):
                    let issue = try value.body.json
                    let scheduledAt =
                        issue.scheduledAt.map {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.calendar = Calendar(
                                identifier: .gregorian
                            )
                            formatter.timeZone = .current
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                            return formatter.string(
                                from: Date(timeIntervalSince1970: $0)
                            )
                        } ?? ""
                    return .init(
                        subject: issue.subject,
                        content: issue.content,
                        scheduledAt: scheduledAt,
                        newsletterId: newsletterId,
                        error: nil
                    )
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
        }

        func edit(
            newsletterId: String,
            issueId: String,
            form: Issue.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterIssueUpdate(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
                        newsletterIssueId: issueId
                    ),
                    query: .init(updateMask: "subject,content"),
                    body: .json(
                        .init(
                            subject: form.normalizedSubject,
                            content: form.content
                        )
                    )
                )
                switch response {
                case .ok: return
                case .badRequest(let response):
                    let data = try JSONEncoder()
                        .encode(
                            try response.body.json
                        )
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
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
        }
    }
}
