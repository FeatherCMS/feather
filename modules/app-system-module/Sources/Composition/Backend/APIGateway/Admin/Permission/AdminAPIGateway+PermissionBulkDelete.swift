import FeatherApplication
import FeatherBackend
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemPermissionBulkDelete(
        _ input: Operations.SystemPermissionBulkDelete.Input
    ) async throws -> Operations.SystemPermissionBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemovePermission()

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
