import FeatherModuleKit
public import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignRemove(
        _ input: Operations.NewsletterCampaignRemove.Input
    ) async throws -> Operations.NewsletterCampaignRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveNewsletterCampaign()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(keys: body.ids)
        )
        return .noContent(.init())
    }

    public func newsletterIssueRemove(
        _ input: Operations.NewsletterIssueRemove.Input
    ) async throws -> Operations.NewsletterIssueRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveNewsletterIssue()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                campaignKey: input.path.newsletterCampaignKey,
                ids: body.ids
            )
        )
        return .noContent(.init())
    }

    public func newsletterSubscriberRemove(
        _ input: Operations.NewsletterSubscriberRemove.Input
    ) async throws -> Operations.NewsletterSubscriberRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveNewsletterSubscriber()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                campaignKey: input.path.newsletterCampaignKey,
                emails: body.ids
            )
        )
        return .noContent(.init())
    }
}
