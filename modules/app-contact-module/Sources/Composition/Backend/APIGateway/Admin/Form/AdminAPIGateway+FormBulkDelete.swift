import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormBulkDelete(
        _ input: Operations.ContactFormBulkDelete.Input
    ) async throws -> Operations.ContactFormBulkDelete.Output {
        let useCase = self.useCases.makeDeleteContactForm()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let didDelete = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload(
                id: $0,
                status: didDelete ? .deleted : .notFound
            )
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: didDelete ? body.ids.count : 0,
                            notFound: didDelete ? 0 : body.ids.count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
