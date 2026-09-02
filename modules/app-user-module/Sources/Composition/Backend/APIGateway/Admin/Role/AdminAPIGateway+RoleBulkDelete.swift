import FeatherApplication
import FeatherBackend
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRoleBulkDelete(
        _ input: Operations.UserRoleBulkDelete.Input
    ) async throws -> Operations.UserRoleBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveRole()

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
