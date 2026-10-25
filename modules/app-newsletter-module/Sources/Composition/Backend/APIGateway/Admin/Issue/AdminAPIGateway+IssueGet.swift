import FeatherModuleKit
import Foundation
import NewsletterModule
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension AdminAPIGateway {
    public func newsletterIssueGet(
        _ input: Operations.NewsletterIssueGet.Input
    ) async throws -> Operations.NewsletterIssueGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeDetailIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    id: input.path.newsletterIssueId
                )
            )
        return .ok(
            .init(
                body: .json(
                    map(result, campaignKey: input.path.newsletterCampaignKey)
                )
            )
        )
    }

    private func map(
        _ value: Issue.Detail.Output,
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
