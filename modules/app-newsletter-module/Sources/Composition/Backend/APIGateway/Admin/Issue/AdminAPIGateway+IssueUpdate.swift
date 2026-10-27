import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case subject
        case content
        case scheduledAt
    }

    public func newsletterIssueUpdate(
        _ input: Operations.NewsletterIssueUpdate.Input
    ) async throws -> Operations.NewsletterIssueUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssuePatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }
        let current = try await self.useCases.makeDetailIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    id: input.path.newsletterIssueId
                )
            )
        let result = try await self.useCases.makeEditIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    id: current.id,
                    subject: try FieldChange(
                        value: body.subject,
                        shouldApply: fields.contains(.subject),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    content: try FieldChange(
                        value: body.content,
                        shouldApply: fields.contains(.content),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    scheduledDate: OptionalFieldChange(
                        value: body.scheduledAt.map {
                            Date(timeIntervalSince1970: $0)
                        },
                        shouldApply: fields.contains(.scheduledAt)
                    )
                )
            )
        if result.scheduledDate == nil {
            try await useCases.makeSendIssueEmails()
                .execute(
                    subject: subject,
                    input: .init(
                        issueId: result.id,
                        newsletterId: result.newsletterId,
                        subject: result.subject,
                        content: result.content,
                        scheduledDate: result.scheduledDate
                    )
                )
        }
        return .ok(
            .init(
                body: .json(
                    map(result, campaignKey: input.path.newsletterCampaignKey)
                )
            )
        )
    }

    private func map(
        _ value: Issue.Edit.Output,
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
