import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterIssueOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
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
                return .init(
                    subject: issue.subject,
                    content: issue.content,
                    scheduledAt: issue.scheduledAt.map {
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        formatter.calendar = Calendar(identifier: .gregorian)
                        formatter.timeZone = .current
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                        return formatter.string(
                            from: Date(timeIntervalSince1970: $0)
                        )
                    } ?? "",
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
    func update(
        newsletterId: String,
        issueId: String,
        form: NewsletterIssueAddForm
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterIssueUpdate(
                path: .init(
                    newsletterCampaignKey: newsletterId,
                    newsletterIssueId: issueId
                ),
                body: .json(
                    .init(
                        subject: form.normalizedSubject,
                        content: form.content,
                        scheduledAt: form.scheduledAtTimestamp
                    )
                )
            )
            switch response {
            case .ok: return
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
