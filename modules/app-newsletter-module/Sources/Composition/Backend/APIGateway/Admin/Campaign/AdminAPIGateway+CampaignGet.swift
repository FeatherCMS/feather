import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterCampaignGet(
        _ input: Operations.NewsletterCampaignGet.Input
    ) async throws -> Operations.NewsletterCampaignGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeDetailCampaign()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterCampaignId)
            )
        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ value: Campaign.Detail.Output
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
