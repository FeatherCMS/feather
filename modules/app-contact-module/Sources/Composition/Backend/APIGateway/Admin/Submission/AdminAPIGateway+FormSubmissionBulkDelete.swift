import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormSubmissionBulkDelete(
        _ input: Operations.ContactFormSubmissionBulkDelete.Input
    ) async throws -> Operations.ContactFormSubmissionBulkDelete.Output {
        let useCase = self.useCases.makeDeleteContactFormSubmission()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let deletedIds = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload(
                id: $0,
                status: deletedIds.contains($0) ? .deleted : .notFound
            )
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deletedIds.count,
                            notFound: body.ids.count - deletedIds.count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
