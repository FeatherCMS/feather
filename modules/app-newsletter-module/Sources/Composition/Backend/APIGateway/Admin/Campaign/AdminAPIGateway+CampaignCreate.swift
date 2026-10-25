import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterCampaignCreate(
        _ input: Operations.NewsletterCampaignCreate.Input
    ) async throws -> Operations.NewsletterCampaignCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterCampaignCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let result = try await self.useCases.makeAddCampaign()
            .execute(
                subject: subject,
                input: .init(
                    key: body.key,
                    name: body.name,
                    fromEmail: body.fromEmail
                )
            )

        return .created(.init(body: .json(map(result))))
    }

    private func map(
        _ value: Campaign.Add.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        .init(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
