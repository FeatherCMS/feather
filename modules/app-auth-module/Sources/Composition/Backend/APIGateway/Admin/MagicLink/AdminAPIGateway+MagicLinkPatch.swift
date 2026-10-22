public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case credentialId
        case isPersistent
    }

    public func authMagicLinkPatch(
        _ input: Operations.AuthMagicLinkPatch.Input
    ) async throws -> Operations.AuthMagicLinkPatch.Output {
        let body: Components.Schemas.AuthMagicLinkPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let authEmailId = try FieldChange(
            value: body.credentialId,
            shouldApply: fields.contains(.credentialId),
            onMissing: { HTTPError(.badRequest) }
        )
        let isPersistent = try FieldChange(
            value: body.isPersistent,
            shouldApply: fields.contains(.isPersistent),
            onMissing: { HTTPError(.badRequest) }
        )

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: MagicLink.Edit.Input(
                id: input.path.authMagicLinkId,
                authEmailId: authEmailId,
                isPersistent: isPersistent
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
