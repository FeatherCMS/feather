import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterIssueList(
        _ input: Operations.NewsletterIssueList.Input
    ) async throws -> Operations.NewsletterIssueList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListIssues()
            .execute(
                subject: subject,
                input: .init(campaignKey: input.path.newsletterCampaignKey)
            )
        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        map(
                            $0,
                            campaignKey: input.path.newsletterCampaignKey
                        )
                    }
                )
            )
        )
    }

    private func map(
        _ value: Issue.List.Item,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueListItemSchema {
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
