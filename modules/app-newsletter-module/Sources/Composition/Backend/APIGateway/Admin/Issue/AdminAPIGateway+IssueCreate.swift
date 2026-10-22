import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueCreate(
        _ input: Operations.NewsletterIssueCreate.Input
    ) async throws -> Operations.NewsletterIssueCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssueCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let created = try await self.useCases.makeAddNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    subject: body.subject,
                    content: body.content
                )
            )

        let issueSchema: Components.Schemas.NewsletterIssueSchema
        if let scheduledAt = body.scheduledAt {
            let scheduled = try await self.useCases
                .makeScheduleNewsletterIssue()
                .execute(
                    subject: subject,
                    input: .init(
                        id: created.id,
                        scheduledDate: .init(timeIntervalSince1970: scheduledAt)
                    )
                )
            try await useCases.makeSendNewsletterIssueEmails()
                .execute(
                    subject: subject,
                    input: .init(
                        issueId: scheduled.id,
                        newsletterId: scheduled.newsletterId,
                        subject: scheduled.subject,
                        content: scheduled.content,
                        scheduledDate: scheduled.scheduledDate
                    )
                )
            issueSchema = map(
                scheduled,
                campaignKey: input.path.newsletterCampaignKey
            )
        }
        else {
            try await useCases.makeSendNewsletterIssueEmails()
                .execute(
                    subject: subject,
                    input: .init(
                        issueId: created.id,
                        newsletterId: created.newsletterId,
                        subject: created.subject,
                        content: created.content,
                        scheduledDate: created.scheduledDate
                    )
                )
            issueSchema = map(
                created,
                campaignKey: input.path.newsletterCampaignKey
            )
        }

        return .created(
            .init(
                body: .json(issueSchema)
            )
        )
    }
}
