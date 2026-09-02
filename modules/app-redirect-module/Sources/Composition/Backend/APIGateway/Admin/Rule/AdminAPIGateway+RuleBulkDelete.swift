import FeatherApplication
import FeatherBackend
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication

extension AdminAPIGateway {

    public func redirectRuleBulkDelete(
        _ input: Operations.RedirectRuleBulkDelete.Input
    ) async throws -> Operations.RedirectRuleBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRemoveRule()
        let subject = try await CurrentSubject.require()

        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
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
