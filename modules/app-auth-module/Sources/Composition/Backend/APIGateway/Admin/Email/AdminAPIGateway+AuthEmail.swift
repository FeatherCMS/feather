public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {
    private func authEmailDetail(id: String, identityId: String, email: String)
        -> Components.Schemas.AuthEmailDetailSchema
    {
        .init(
            id: id,
            identityId: identityId,
            email: email
        )
    }

    public func authEmailCreate(
        _ input: Operations.AuthEmailCreate.Input
    ) async throws -> Operations.AuthEmailCreate.Output {
        let body: Components.Schemas.AuthEmailCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await useCases.makeAddAuthEmail()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    identityId: body.identityId,
                    email: body.email
                )
            )
        return .created(
            .init(
                body: .json(
                    authEmailDetail(
                        id: result.id,
                        identityId: result.identityId,
                        email: result.email
                    )
                )
            )
        )
    }

    public func authEmailList(
        _ input: Operations.AuthEmailList.Input
    ) async throws -> Operations.AuthEmailList.Output {
        let result = try await useCases.makeListAuthEmails()
            .execute(subject: try await CurrentSubject.require())
        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        authEmailDetail(
                            id: $0.id,
                            identityId: $0.identityId,
                            email: $0.email
                        )
                    }
                )
            )
        )
    }

    public func authEmailGet(
        _ input: Operations.AuthEmailGet.Input
    ) async throws -> Operations.AuthEmailGet.Output {
        let result = try await useCases.makeListAuthEmails()
            .execute(subject: try await CurrentSubject.require())
        guard
            let value = result.items.first(where: {
                $0.id == input.path.authEmailId
            })
        else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "Auth email not found",
                userFriendlyMessage: "Auth email not found"
            )
        }
        return .ok(
            .init(
                body: .json(
                    authEmailDetail(
                        id: value.id,
                        identityId: value.identityId,
                        email: value.email
                    )
                )
            )
        )
    }

    public func authEmailPatch(
        _ input: Operations.AuthEmailPatch.Input
    ) async throws -> Operations.AuthEmailPatch.Output {
        let body: Components.Schemas.AuthEmailPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let current = try await useCases.makeListAuthEmails()
            .execute(subject: try await CurrentSubject.require())
            .items
            .first { $0.id == input.path.authEmailId }
        guard let current else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "Auth email not found",
                userFriendlyMessage: "Auth email not found"
            )
        }
        let result = try await useCases.makeEditAuthEmail()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    id: current.id,
                    identityId: body.identityId ?? current.identityId,
                    email: body.email ?? current.email
                )
            )
        return .ok(
            .init(
                body: .json(
                    authEmailDetail(
                        id: result.id,
                        identityId: result.identityId,
                        email: result.email
                    )
                )
            )
        )
    }

    public func authEmailRemove(
        _ input: Operations.AuthEmailRemove.Input
    ) async throws -> Operations.AuthEmailRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await useCases.makeRemoveAuthEmails()
            .execute(
                subject: try await CurrentSubject.require(),
                ids: body.ids
            )
        return .noContent(.init())
    }
}
