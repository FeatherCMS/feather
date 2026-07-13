import AdminOpenAPI
import Application
import ContactApplication
import NewsletterApplication
import Foundation

extension AdminAPI {
    func contactNewsletterIssueCreate(
        _ input: Operations.ContactNewsletterIssueCreate.Input
    ) async throws -> Operations.ContactNewsletterIssueCreate.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Issues.create)
        let body: Components.Schemas.ContactNewsletterIssueCreateSchema
        switch input.body {
        case let .json(value): body = value
        }

        var result = try await modules.newsletter.makeCreateNewsletterIssue()
            .execute(
                .init(
                    newsletterId: input.path.contactNewsletterId,
                    subject: body.subject,
                    content: body.content
                )
            )

        if let scheduledAt = body.scheduledAt {
            result = try await modules.newsletter.makeScheduleNewsletterIssue()
                .execute(
                    .init(
                        id: result.id,
                        scheduledDate: .init(timeIntervalSince1970: scheduledAt)
                    )
                )
        }

        return .created(.init(body: .json(map(result))))
    }
}
