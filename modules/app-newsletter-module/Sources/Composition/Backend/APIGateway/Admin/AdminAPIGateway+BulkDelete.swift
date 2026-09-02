import FeatherApplication
import FeatherBackend
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignBulkDelete(
        _ input: Operations.NewsletterCampaignBulkDelete.Input
    ) async throws -> Operations.NewsletterCampaignBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteNewsletterCampaign()
        _ = try await useCase.execute(subject: subject, input: .init(ids: body.ids))
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.count,
                            notFound: 0,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func newsletterIssueBulkDelete(
        _ input: Operations.NewsletterIssueBulkDelete.Input
    ) async throws -> Operations.NewsletterIssueBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteNewsletterIssue()
        _ = try await useCase.execute(subject: subject, input: .init(ids: body.ids))
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.count,
                            notFound: 0,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func newsletterSubscriberBulkDelete(
        _ input: Operations.NewsletterSubscriberBulkDelete.Input
    ) async throws -> Operations.NewsletterSubscriberBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteNewsletterSubscriber()
        try await useCase.execute(
            subject: subject,
            input: .init(
                newsletterId: input.path.newsletterCampaignId,
                emails: body.ids
            )
        )
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.count,
                            notFound: 0,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
