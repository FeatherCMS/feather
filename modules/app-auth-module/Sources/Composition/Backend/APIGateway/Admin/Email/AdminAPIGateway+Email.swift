public import AuthAdminAPI
import AuthApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case identityId
        case email
    }
    private func authEmailDetail(id: String, identityId: String, email: String)
        -> Components.Schemas.AuthEmailSchemasDetail
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
        let body: Components.Schemas.AuthEmailSchemasCreate
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
        let body: Components.Schemas.AuthEmailSchemasPatch
        switch input.body {
        case .json(let value): body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let identityId = try FieldChange(
            value: body.identityId,
            shouldApply: fields.contains(.identityId),
            onMissing: { HTTPError(.badRequest) }
        )
        let email = try FieldChange(
            value: body.email,
            shouldApply: fields.contains(.email),
            onMissing: { HTTPError(.badRequest) }
        )

        let result = try await useCases.makeEditAuthEmail()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    id: input.path.authEmailId,
                    identityId: identityId,
                    email: email
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
