import AdminOpenAPI
import NewsletterApplication
import NewsletterDomain
import Foundation

extension AdminAPI {
    func contactNewsletterIssueUpdate(
        _ input: Operations.ContactNewsletterIssueUpdate.Input
    ) async throws -> Operations.ContactNewsletterIssueUpdate.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Issues.update
        )
        let body: Components.Schemas.ContactNewsletterIssuePatchSchema
        switch input.body {
        case let .json(value): body = value
        }
        let current = try await modules.newsletter.makeGetNewsletterIssue()
            .execute(
                .init(id: input.path.contactNewsletterIssueId)
            )
        let result = try await modules.newsletter.makeUpdateNewsletterIssue()
            .execute(
                .init(
                    id: current.id,
                    subject: body.subject ?? current.subject,
                    content: body.content ?? current.content,
                    scheduledDate: body.scheduledAt.map {
                        Date(timeIntervalSince1970: $0)
                    } ?? current.scheduledDate
                )
            )
        if result.scheduledDate == nil && result.status == .draft {
            try await modules.newsletter.enqueueIssueEmails(issue: result)
        }
        return .ok(.init(body: .json(map(result))))
    }
}
