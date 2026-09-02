import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFieldBulkDelete(
        _ input: Operations.ContactFieldBulkDelete.Input
    ) async throws -> Operations.ContactFieldBulkDelete.Output {
        let useCase = self.useCases.makeDeleteFormField()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let deleted = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(ids: body.ids, formId: nil)
        )
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload(
                id: $0,
                status: deleted ? .deleted : .notFound
            )
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deleted ? body.ids.count : 0,
                            notFound: deleted ? 0 : body.ids.count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
