import FeatherApplication
import FeatherBackend
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityRemove(
        _ input: Operations.UserIdentityRemove.Input
    ) async throws -> Operations.UserIdentityRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveIdentity()

        let deletedIds = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.DeleteResultListSchemaPayload(
                id: $0,
                status: deletedIds.contains($0) ? .deleted : .notFound
            )
        }

        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: body.ids.count,
                                deleted: deletedIds.count,
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
