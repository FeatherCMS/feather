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
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(id: id, status: .deleted)
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
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(id: id, status: .deleted)
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
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { email in
                    try await useCase.execute(
                        subject: subject,
                        input: .init(
                            newsletterId: input.path.newsletterCampaignId,
                            email: email
                        )
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(id: email, status: .deleted)
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
