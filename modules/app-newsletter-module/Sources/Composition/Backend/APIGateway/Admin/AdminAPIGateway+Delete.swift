import FeatherApplication
import FeatherBackend
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignDelete(
        _ input: Operations.NewsletterCampaignDelete.Input
    ) async throws -> Operations.NewsletterCampaignDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteNewsletterCampaign()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.DeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: results.count,
                                deleted: results.count,
                                omitted:
                                    results.filter { $0.status != .deleted }
                                    .count
                            ) : nil
                    )
                )
            )
        )
    }

    public func newsletterIssueDelete(
        _ input: Operations.NewsletterIssueDelete.Input
    ) async throws -> Operations.NewsletterIssueDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteNewsletterIssue()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.DeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: results.count,
                                deleted: results.count,
                                omitted:
                                    results.filter { $0.status != .deleted }
                                    .count
                            ) : nil
                    )
                )
            )
        )
    }

    public func newsletterSubscriberDelete(
        _ input: Operations.NewsletterSubscriberDelete.Input
    ) async throws -> Operations.NewsletterSubscriberDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
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
            Components.Schemas.DeleteResponseSchema
                .ResultsPayloadPayload(id: $0, status: .deleted)
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: results.count,
                                deleted: results.count,
                                omitted:
                                    results.filter { $0.status != .deleted }
                                    .count
                            ) : nil
                    )
                )
            )
        )
    }
}
