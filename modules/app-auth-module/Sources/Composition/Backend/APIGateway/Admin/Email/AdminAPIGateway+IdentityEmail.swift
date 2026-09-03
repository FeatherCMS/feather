import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    private func identityEmailDetail(_ value: IdentityEmailDetail)
        -> Components.Schemas.AuthIdentityEmailDetailSchema
    {
        .init(
            id: value.id,
            identityId: value.identityId,
            email: value.email,
            isPrimary: value.isPrimary,
            isVerified: value.isVerified
        )
    }

    public func authIdentityEmailCreate(
        _ input: Operations.AuthIdentityEmailCreate.Input
    ) async throws -> Operations.AuthIdentityEmailCreate.Output {
        let body: Components.Schemas.AuthIdentityEmailCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result = try await useCases.makeAddIdentityEmail()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    identityId: body.identityId,
                    email: body.email,
                    isPrimary: body.isPrimary ?? true,
                    isVerified: body.isVerified ?? false
                )
            )
        return .created(.init(body: .json(identityEmailDetail(result))))
    }

    public func authIdentityEmailList(
        _ input: Operations.AuthIdentityEmailList.Input
    ) async throws -> Operations.AuthIdentityEmailList.Output {
        let result = try await useCases.makeListIdentityEmails()
            .execute(subject: try await CurrentSubject.require())
        return .ok(.init(body: .json(result.map(identityEmailDetail))))
    }

    public func authIdentityEmailGet(
        _ input: Operations.AuthIdentityEmailGet.Input
    ) async throws -> Operations.AuthIdentityEmailGet.Output {
        let result = try await useCases.makeListIdentityEmails()
            .execute(subject: try await CurrentSubject.require())
        guard
            let value = result.first(where: {
                $0.id == input.path.authIdentityEmailId
            })
        else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "Identity email not found",
                userFriendlyMessage: "Identity email not found"
            )
        }
        return .ok(.init(body: .json(identityEmailDetail(value))))
    }

    public func authIdentityEmailPatch(
        _ input: Operations.AuthIdentityEmailPatch.Input
    ) async throws -> Operations.AuthIdentityEmailPatch.Output {
        let body: Components.Schemas.AuthIdentityEmailPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let current = try await useCases.makeListIdentityEmails()
            .execute(subject: try await CurrentSubject.require())
            .first { $0.id == input.path.authIdentityEmailId }
        guard let current else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "Identity email not found",
                userFriendlyMessage: "Identity email not found"
            )
        }
        let result = try await useCases.makeEditIdentityEmail()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    id: current.id,
                    identityId: body.identityId ?? current.identityId,
                    email: body.email ?? current.email,
                    isPrimary: body.isPrimary ?? current.isPrimary,
                    isVerified: body.isVerified ?? current.isVerified
                )
            )
        return .ok(.init(body: .json(identityEmailDetail(result))))
    }

    public func authIdentityEmailDelete(
        _ input: Operations.AuthIdentityEmailDelete.Input
    ) async throws -> Operations.AuthIdentityEmailDelete.Output {
        let ids: [String]
        switch input.body {
        case .json(let value): ids = value.ids
        }
        _ = try await useCases.makeRemoveIdentityEmails()
            .execute(subject: try await CurrentSubject.require(), ids: ids)
        return .ok(.init(body: .json(.init(results: nil, summary: nil))))
    }
}
