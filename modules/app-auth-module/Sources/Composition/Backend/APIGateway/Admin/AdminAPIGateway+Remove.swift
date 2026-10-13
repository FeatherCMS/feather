public import AuthAdminAPI
import AuthApplication
import FeatherContracts

extension AdminAPIGateway {
    public func authRolePermissionRemove(
        _ input: Operations.AuthRolePermissionRemove.Input
    ) async throws -> Operations.AuthRolePermissionRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveRolePermission()
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
                                requested: results.count,
                                deleted:
                                    results.filter { $0.status == .deleted }
                                    .count,
                                omitted:
                                    results.filter { $0.status != .deleted }
                                    .count
                            ) : nil
                    )
                )
            )
        )
    }

    public func userIdentitySessionRemove(
        _ input: Operations.UserIdentitySessionRemove.Input
    ) async throws -> Operations.UserIdentitySessionRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let removeSession = useCases.makeRemoveSession()
        let deletedIds = try await removeSession.execute(
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
                                requested: results.count,
                                deleted:
                                    results.filter { $0.status == .deleted }
                                    .count,
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
