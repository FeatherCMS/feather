import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    private func authEmailDetail(_ value: AuthEmailDetail)
        -> Components.Schemas.AuthEmailDetailSchema
    {
        .init(
            id: value.id,
            identityId: value.identityId,
            email: value.email
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
        return .created(.init(body: .json(authEmailDetail(result))))
    }

    public func authEmailList(
        _ input: Operations.AuthEmailList.Input
    ) async throws -> Operations.AuthEmailList.Output {
        let result = try await useCases.makeListAuthEmails()
            .execute(subject: try await CurrentSubject.require())
        return .ok(.init(body: .json(result.map(authEmailDetail))))
    }

    public func authEmailGet(
        _ input: Operations.AuthEmailGet.Input
    ) async throws -> Operations.AuthEmailGet.Output {
        let result = try await useCases.makeListAuthEmails()
            .execute(subject: try await CurrentSubject.require())
        guard
            let value = result.first(where: {
                $0.id == input.path.authEmailId
            })
        else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "Auth email not found",
                userFriendlyMessage: "Auth email not found"
            )
        }
        return .ok(.init(body: .json(authEmailDetail(value))))
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
        return .ok(.init(body: .json(authEmailDetail(result))))
    }

    public func authEmailDelete(
        _ input: Operations.AuthEmailDelete.Input
    ) async throws -> Operations.AuthEmailDelete.Output {
        let ids: [String]
        switch input.body {
        case .json(let value): ids = value.ids
        }
        _ = try await useCases.makeRemoveAuthEmails()
            .execute(subject: try await CurrentSubject.require(), ids: ids)
        return .ok(.init(body: .json(.init(results: nil, summary: nil))))
    }
}
