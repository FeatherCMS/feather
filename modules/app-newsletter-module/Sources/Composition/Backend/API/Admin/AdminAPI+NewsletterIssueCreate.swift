import FeatherApplication
import FeatherContracts
import Foundation
import NewsletterAdminAPI
import NewsletterApplication

extension NewsletterBackend {
    public func newsletterIssueCreate(
        _ input: Operations.NewsletterIssueCreate.Input
    ) async throws -> Operations.NewsletterIssueCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssueCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        var result = try await self.makeCreateNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(
                    newsletterId: input.path.newsletterCampaignId,
                    subject: body.subject,
                    content: body.content
                )
            )

        if let scheduledAt = body.scheduledAt {
            result = try await self.makeScheduleNewsletterIssue()
                .execute(
                    subject: subject,
                    input: .init(
                        id: result.id,
                        scheduledDate: .init(timeIntervalSince1970: scheduledAt)
                    )
                )
        }

        if body.scheduledAt == nil {
            try await self.enqueueIssueEmails(issue: result)
        }

        return .created(.init(body: .json(map(result))))
    }
}
