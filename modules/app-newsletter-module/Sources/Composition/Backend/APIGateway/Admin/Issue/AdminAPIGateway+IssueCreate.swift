import FeatherModuleKit
import Foundation
import NewsletterModule
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension AdminAPIGateway {
    public func newsletterIssueCreate(
        _ input: Operations.NewsletterIssueCreate.Input
    ) async throws -> Operations.NewsletterIssueCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssueCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let created = try await self.useCases.makeAddIssue()
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
                .makeScheduleIssue()
                .execute(
                    subject: subject,
                    input: .init(
                        id: created.id,
                        scheduledDate: .init(timeIntervalSince1970: scheduledAt)
                    )
                )
            try await useCases.makeSendIssueEmails()
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
            try await useCases.makeSendIssueEmails()
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

    private func map(
        _ value: Issue.Schedule.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        .init(
            id: value.id,
            campaignKey: campaignKey,
            subject: value.subject,
            content: value.content,
            status: value.status.rawValue,
            scheduledAt: value.scheduledDate?.timeIntervalSince1970,
            sentAt: value.sentDate?.timeIntervalSince1970,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }

    private func map(
        _ value: Issue.Add.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        .init(
            id: value.id,
            campaignKey: campaignKey,
            subject: value.subject,
            content: value.content,
            status: value.status.rawValue,
            scheduledAt: value.scheduledDate?.timeIntervalSince1970,
            sentAt: value.sentDate?.timeIntervalSince1970,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
