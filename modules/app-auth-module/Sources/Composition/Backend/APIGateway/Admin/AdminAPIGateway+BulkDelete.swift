import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts
import UserApplication
import UserBackend

extension AdminAPIGateway {
    public func authRolePermissionBulkDelete(
        _ input: Operations.AuthRolePermissionBulkDelete.Input
    ) async throws -> Operations.AuthRolePermissionBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveRolePermission()
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
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func userIdentitySessionBulkDelete(
        _ input: Operations.UserIdentitySessionBulkDelete.Input
    ) async throws -> Operations.UserIdentitySessionBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let removeSession = useCases.makeRemoveSession()
        let deleted = try await removeSession.execute(
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
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
