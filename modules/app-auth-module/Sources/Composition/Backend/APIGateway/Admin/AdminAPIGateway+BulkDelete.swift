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
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let parts = id.split(separator: ":", maxSplits: 1)
                        .map(String.init)
                    guard parts.count == 2 else {
                        return Components.Schemas.BulkDeleteResponseSchema
                            .ResultsPayloadPayload(id: id, status: .notFound)
                    }
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(roleId: parts[0], permissionId: parts[1])
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
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
        let getIdentity = useCases.makeGetIdentity()
        let getSession = useCases.makeGetSession()
        let removeSession = useCases.makeRemoveSession()
        _ = try await getIdentity.execute(
            subject: subject,
            input: .init(id: input.path.userIdentityId)
        )
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let session = try await getSession.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    guard session.identityId == input.path.userIdentityId else {
                        return Components.Schemas.BulkDeleteResponseSchema
                            .ResultsPayloadPayload(id: id, status: .notFound)
                    }
                    let deleted = try await removeSession.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
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
