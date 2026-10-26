import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterIssueDeliveryList(
        _ input: Operations.NewsletterIssueDeliveryList.Input
    ) async throws -> Operations.NewsletterIssueDeliveryList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListDeliveries()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    issueId: input.path.newsletterIssueId
                )
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }

    private func map(
        _ value: Delivery.List.Item
    ) -> Components.Schemas.NewsletterDeliverySchema {
        .init(
            subscriberEmail: value.subscriberEmail,
            status: value.status.rawValue,
            sentAt: value.sentDate?.timeIntervalSince1970,
            failureReason: value.failureReason,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
