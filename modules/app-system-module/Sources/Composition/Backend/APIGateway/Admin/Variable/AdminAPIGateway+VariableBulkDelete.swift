import FeatherApplication
import FeatherBackend
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemVariableBulkDelete(
        _ input: Operations.SystemVariableBulkDelete.Input
    ) async throws -> Operations.SystemVariableBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRemoveVariable()
        let subject = try await CurrentSubject.require()

        let deletedIds = try await useCase.execute(
            subject: subject,
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
