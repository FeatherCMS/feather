public import AuthAdminAPI
import AuthApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case userId
        case email
        case password
    }

    public func authCredentialPatch(
        _ input: Operations.AuthCredentialPatch.Input
    ) async throws -> Operations.AuthCredentialPatch.Output {
        let body: Components.Schemas.AuthCredentialPatchSchema
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

        let userId = try FieldChange(
            value: body.userId,
            shouldApply: fields.contains(.userId),
            onMissing: { HTTPError(.badRequest) }
        )
        let email = try FieldChange(
            value: body.email,
            shouldApply: fields.contains(.email),
            onMissing: { HTTPError(.badRequest) }
        )
        let password = try FieldChange(
            value: body.password,
            shouldApply: fields.contains(.password),
            onMissing: { HTTPError(.badRequest) }
        )

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.authCredentialId,
                userId: userId,
                email: email,
                password: password
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
