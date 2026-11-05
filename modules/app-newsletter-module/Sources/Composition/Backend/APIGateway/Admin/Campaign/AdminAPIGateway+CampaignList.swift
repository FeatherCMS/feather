import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterCampaignList(
        _ input: Operations.NewsletterCampaignList.Input
    ) async throws -> Operations.NewsletterCampaignList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListCampaigns()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.items.map(map))))
    }

    private func map(
        _ value: Campaign.List.Item
    ) -> Components.Schemas.NewsletterCampaignSchema {
        .init(
            id: value.id,
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
